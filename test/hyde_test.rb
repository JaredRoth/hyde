require_relative 'test_helper'
require_relative '../lib/hyde'

class HydeTest < Minitest::Test
  DIR = Dir.pwd

  def setup
    @hyde = Hyde.new(["new", "test-dir"])
    $stdout = StringIO.new
  end

  def teardown
    # FileHandler.new('test-dir').move(DIR)
    FileUtils.remove_dir('test-dir', force = true)
  end

  def test_it_removes_leading_slash
    assert_equal "test-dir (new)", @hyde.process_subcommand
  end

  def test_it_understands_the_new_command
    assert_equal "test-dir (new)", @hyde.process_subcommand
  end

  def test_it_returns_error_if_dir_exists
    Builder.new('test-dir').create_tree
    assert_equal "Error", @hyde.process_subcommand
  end

  def test_it_understands_the_build_command
    @hyde.process_subcommand
    build = Hyde.new(["build", "test-dir"])
    assert_equal "test-dir (build)", build.process_subcommand
  end

  def test_it_understands_the_post_command
    @hyde.process_subcommand
    post = Hyde.new(["post", "test-dir", "My Post"])
    assert_equal "test-dir, My Post (post)", post.process_subcommand
  end

  def test_it_understands_the_watchfs_command_with_one_or_two_ARGS
    @hyde.process_subcommand
    watchfs = Hyde.new(["watchfs", "test-dir", "0.1"])
    assert_equal "test-dir, (watchfs)", watchfs.process_subcommand
  end

  def test_it_rejects_bad_commands
    pizza = Hyde.new(["pizza", "test-dir"])
    assert_equal "Error", pizza.process_subcommand
  end
end
