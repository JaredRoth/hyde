require_relative 'test_helper'
require_relative '../lib/hyde'

class HydeTest < Minitest::Test
  DIR = Dir.pwd

  def setup
    @fh = FileHandler.new('test-dir')
  end

  def teardown
    @fh.move(DIR)
    FileUtils.remove_dir('test-dir', force = true)
  end

  def test_it_understands_the_new_command
    assert_equal "test-dir (new)", Hyde.process_subcommand(["new", "test-dir"])
  end

  def test_it_returns_error_if_dir_exists
    @fh.create_tree
    assert_equal "Error",
    Hyde.process_subcommand(['new', 'test-dir'])
  end

  def test_it_understands_the_build_command
    Hyde.process_subcommand(['new', 'test-dir'])
    assert_equal "test-dir (build)", Hyde.process_subcommand(["build", "test-dir"])
  end

  def test_it_understands_the_post_command
    Hyde.process_subcommand(['new', 'test-dir'])
    assert_equal "test-dir, My Post (post)", Hyde.process_subcommand(["post", "test-dir", "My Post"])
  end

  def test_it_understands_the_watchfs_command_with_one_or_two_ARGS
    Hyde.process_subcommand(['new', 'test-dir'])
    assert_equal "test-dir, (watchfs)", Hyde.process_subcommand(["watchfs", "test-dir", "0.1"])
  end
end
