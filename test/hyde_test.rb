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
    hyde = Hyde.new(["new", "test-dir"])
    assert_equal "test-dir (new)", hyde.process_subcommand
  end

  def test_it_returns_error_if_dir_exists
    hyde = Hyde.new(["new", "test-dir"])
    @fh.create_tree
    assert_equal "Error", hyde.process_subcommand
  end

  def test_it_understands_the_build_command
    hyde = Hyde.new(["new", "test-dir"])
    hyde.process_subcommand
    hyde = Hyde.new(["build", "test-dir"])
    assert_equal "test-dir (build)", hyde.process_subcommand
  end

  def test_it_understands_the_post_command
    hyde = Hyde.new(["new", "test-dir"])
    hyde.process_subcommand
    hyde = Hyde.new(["post", "test-dir", "My Post"])
    assert_equal "test-dir, My Post (post)", hyde.process_subcommand
  end

  def test_it_understands_the_watchfs_command_with_one_or_two_ARGS
    hyde = Hyde.new(["new", "test-dir"])
    hyde.process_subcommand
    hyde = Hyde.new(["watchfs", "test-dir", "0.1"])
    assert_equal "test-dir, (watchfs)", hyde.process_subcommand
  end
end
