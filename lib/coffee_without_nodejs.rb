#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'coffee_without_nodejs/compiler'
require 'coffee_without_nodejs/watcher'

module CoffeeWithoutNodejs
  def self.compile(coffee, bare=true, create_target_jsfile=false)
    if File.file?(coffee)
      CoffeeCompiler.compile_file(coffee, bare, create_target_jsfile)
    else
      CoffeeCompiler.compile(coffee, bare)
    end
  end

  def self.watch!
    CoffeeWatcher.instance
  end
end
