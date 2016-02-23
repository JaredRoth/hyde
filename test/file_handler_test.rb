require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/file_handler'

class FileHandlerTest < Minitest::Test
  def setup
    @start_dir = Dir.pwd
    @fh = FileHandler.new
  end

  def test_it_navigates_to_the_input_directory
    @fh.move('./lib')
    assert_equal "lib", File.basename(Dir.pwd)

    @fh.move(@start_dir)
  end

  def test_it_recognizes_tilde_properly
    @fh.create('~/test-dir')
    @fh.move('~/test-dir')

    assert_equal "#{Dir.home}/test-dir", Dir.pwd
    @fh.move(@start_dir)
  end

  def test_it_creates_an_empty_directory
    @fh.create('test-dir')

    @fh.move('test-dir/output')
    assert_equal 'output', File.basename(Dir.pwd)
    @fh.move('../..')

    @fh.move('test-dir/source')
    assert_equal 'source', File.basename(Dir.pwd)
    @fh.move('../..')

    @fh.move('test-dir/source/css')
    assert_equal 'css', File.basename(Dir.pwd)
    @fh.move('../../..')

    @fh.move('test-dir/source/pages')
    assert_equal 'pages', File.basename(Dir.pwd)
    @fh.move('../../..')

    @fh.move('test-dir/source/posts')
    assert_equal 'posts', File.basename(Dir.pwd)
    @fh.move(@start_dir)
  end

  def test_it_makes_a_new_empty_file_in_a_directory
    @fh.create('test-dir')

    @fh.move('test-dir/source/css')
    main = @fh.touch('main.css')
    assert File.exist?(main)
    assert_equal "", File.read('main.css')

    @fh.move(@start_dir)
  end
end
