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
    argv = ['-a', 'dummy_files']
    command = Command.new(argv)
    assert_equal command.options, [:a]
    assert_equal command.directory_name, ['dummy_files']
  end

  def test_parse_command_dir_name
    argv = ['dummy_files']
    command = Command.new(argv)
    assert_empty command.options
    assert_equal command.directory_name, ['dummy_files']
  end

  def test_parse_command_options
    argv = ['-a']
    command = Command.new(argv)
    assert_empty command.directory_name
    assert_equal command.options, [:a]
  end

  def test_empty_directory
    argv = ['-a', 'dummy_files2']
    command = Command.new(argv)
    assert_empty command.send(:fetch_files)
  end

  def test_file_stats_exist
    argv = ['-a']
    command = Command.new(argv).send(:fetch_files)[2]
    assert_equal command.file_stats[:blocks], 0
    assert_equal command.file_stats[:type], 'file'
    assert_equal command.file_stats[:permission], '-rw-r--r--'
    assert_equal command.file_stats[:nlink], 1
    assert_equal command.file_stats[:owner], 'yumiya'
    assert_equal command.file_stats[:group], 'staff'
    assert_equal command.file_stats[:size], 0
    assert_equal command.file_stats[:date], { year: '2022', month: '06', day: '09', hour: '23', min: '10' }
    assert_equal command.file_stats[:name], '.gitkeep'
  end
end
