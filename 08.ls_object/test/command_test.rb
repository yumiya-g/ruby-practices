# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../command'

class CommandTest < Minitest::Test
  def test_parse_command_no_options_and_dir_name
    argv = []
    command = Command.new(argv)
    assert_empty command.directory_name
    assert_empty command.options
  end

  def test_parse_command_dir_name_and_options
    argv = ['-a', 'test_files']
    command = Command.new(argv)
    assert_equal command.options, [:a]
    assert_equal command.directory_name, ['test_files']
  end

  def test_parse_command_dir_name
    argv = ['test_files']
    command = Command.new(argv)
    assert_empty command.options
    assert_equal command.directory_name, ['test_files']
  end

  def test_parse_command_options
    argv = ['-a']
    command = Command.new(argv)
    assert_empty command.directory_name
    assert_equal command.options, [:a]
  end
end
