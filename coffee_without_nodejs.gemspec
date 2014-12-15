#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.expand_path('../lib/coffee_without_nodejs/version', __FILE__)

Gem::Specification.new do |s|
  s.name                        = 'coffee_without_nodejs'
  s.version                     = CoffeeWithoutNodejs::VERSION
  s.date                        = Time.now.strftime('%F')
  s.required_ruby_version       = '>= 1.9.1'
  s.authors                     = ['Billy.Zheng(zw963)']
  s.email                       = ['zw963@163.com']
  s.summary                     = 'Simple & Smart CoffeeScript command-line compiler.'
  s.description                 = 'Simple & Smart CoffeeScript command-line compiler. No need Nodejs installed.'
  s.homepage                    = 'http://github.com/zw963/coffee_without_nodejs'
  s.license                     = 'MIT'
  s.require_paths               = ['lib']
  s.files                       = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.executables                 = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f) }

  s.add_runtime_dependency 'execjs','~>2.2'
  s.add_runtime_dependency 'rev','~>0.3'
  s.add_runtime_dependency 'coderay','~>1.1'
  s.add_development_dependency 'ritual', '~>0.4'
end
