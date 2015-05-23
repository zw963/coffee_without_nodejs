#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'execjs'
require 'pathname'

module CoffeeWithoutNodejs
  module CoffeeCompiler
    class << self
      attr_writer :source

      def source
        @source ||= File.read(File.expand_path('../compiler/coffee-script.js', __FILE__))
      end

      def wrapper
        wrapper = <<-WRAPPER
(function(script, options) {
    try {
        return CoffeeScript.compile(script, options);
    } catch (err) {
        if (err instanceof SyntaxError && err.location) {
            throw new SyntaxError([options.filename, err.location.first_line + 1, err.location.first_column + 1].join(":") + ": " + err.message)
        } else {
            throw err;
        }
    }
})
WRAPPER
      end

      def compiler
        @coffee ||= ExecJS.compile(source)
      end

      def compile(script, bare=true)
        compiler.call(wrapper, script, bare: bare)
      end

      def compile_file(file, bare=true)
        root_dir = Pathname(Dir.pwd)
        file_path = Pathname(File.expand_path(file))
        source_code = file_path.read

        js_path, map_path = create_js_path_from(file_path)

        source_files = file_path.relative_path_from(js_path.dirname).to_s
        generated_file = js_path.relative_path_from(js_path.dirname).to_s

        File.open(js_path, 'wb') do |f|
          f.print "#{ENV['JS_SHEBANG']}\n\n" if ENV['JS_SHEBANG']
          f.print compiler.call(wrapper, source_code, bare: bare), "\n//# sourceMappingURL=#{File.basename(map_path)}"
        end
        File.open(map_path, 'wb') {|f| f.print compiler.call(wrapper, source_code, sourceMap: true, sourceFiles: [source_files], generatedFile: generated_file)["v3SourceMap"] }

        puts "[1m[32m==>[0m #{js_path.relative_path_from(root_dir)}"

        js_path
      rescue ExecJS::RuntimeError
        error_msg = "[#{file_path.relative_path_from(root_dir)}]: #{$!.message}"
        `notify-send "#{error_msg}" -t 5000` if system 'which notify-send &>/dev/null'
        puts error_msg
      end

      def create_js_path_from(path)
        path.descend do |x|
          if x.basename.to_s == 'coffee'
            js_root = x.sub(/\/coffee$/, '/js')
            js_path = path.sub('/coffee/', '/js/').sub(/\.js\.coffee$|\.coffee$/, '.js')
            dirname = js_path.dirname

            dirname.mkpath unless dirname.exist?

            return [js_path, js_path.sub_ext('.map'), js_root]
          end
        end
        js = path.sub(/\.js\.coffee$|\.coffee$/, '.js')
        return [js, js.sub_ext('.map')]
      end
    end
  end
end
