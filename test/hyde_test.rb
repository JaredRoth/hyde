require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/hyde'

class FileHandlerTest < Minitest::Test
  def test_it_returns_error_if_dir_exists
    @start_dir = Dir.pwd
    @fh = FileHandler.new


    @fh.create_tree('test-dir')

    assert_equal "That path already exists! Try again.",
  Hyde.do_the_thing('new', 'test-dir')

  end
end
