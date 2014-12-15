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

      def compile(coffee_script, bare=true)
        compiler.call(wrapper, coffeescript, bare: bare)
      end

      def compile_file(file, bare=true)
        file_path = Pathname(File.expand_path(file))
        source_code = file_path.read

        js_path, map_path, dirname = create_js_path_from(file_path)

        source_files = file_path.relative_path_from(dirname).to_s
        generated_file = js_path.relative_path_from(dirname).to_s

        File.open(js_path, 'wb') {|f| f.print compiler.call(wrapper, source_code, bare: bare), "\n//# sourceMappingURL=#{File.basename(map_path)}" }
        File.open(map_path, 'wb') {|f| f.print compiler.call(wrapper, source_code, sourceMap: true, sourceFiles: [source_files], generatedFile: generated_file)["v3SourceMap"] }

        puts "[1m[32m==>[0m #{js_path.relative_path_from(dirname.parent)}"

        js_path
      rescue ExecJS::RuntimeError
        `notify-send "#{File.basename(file)}" -t 1000` if system 'which notify-send &>/dev/null'
        puts "#{$!.backtrace[0]}: #{$!.message} (#{$!.class})", $!.backtrace[1..-1]
      end

      def create_js_path_from(path)
        path.descend do |x|
          if x.basename.to_s == 'coffee'
            js = path.sub('/coffee/', '/js/').sub(/\.js\.coffee$|\.coffee$/, '.js')
            dirname = js.dirname

            dirname.mkpath unless dirname.exist?

            return [js, js.sub_ext('.map'), dirname]
          end
        end
        js = path.sub(/\.js\.coffee$|\.coffee$/, '.js')
        return [js, js.sub_ext('.map'), js.dirname]
      end
    end
  end
end
