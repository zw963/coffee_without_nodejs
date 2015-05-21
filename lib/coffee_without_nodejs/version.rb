#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module CoffeeWithoutNodejs
  VERSION = [0, 2, 0]

  class << VERSION
    def to_s
      join(?.)
    end
  end
end
