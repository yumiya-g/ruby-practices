#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'
require_relative 'command'

def main
  Command.new(ARGV).display_files
end

main
