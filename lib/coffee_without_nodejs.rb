#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'coffee_without_nodejs/compiler'
require 'coffee_without_nodejs/watcher'

module CoffeeWithoutNodejs
  def self.compile(js, bare=true)
    if File.file?(js)
      js_file = CoffeeCompiler.compile_file(js, bare)
      CoffeeWatcher.new(js)
      js_file
    else
      CoffeeCompiler.compile(js, bare)
    end
  end

  def self.watch!
    CoffeeWatcher.run
  end
end
