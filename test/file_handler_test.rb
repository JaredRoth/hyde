require 'minitest/autorun'
require 'minitest/pride'
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
    @fh.create_tree("#{Dir.home}/test-dir")
    @fh.move("#{Dir.home}/test-dir")

    assert_equal "#{Dir.home}/test-dir", Dir.pwd
    @fh.move("../")
    FileUtils.remove_dir('./test-dir', force = true)
    @fh.move(@start_dir)
  end

  def test_it_creates_an_empty_directory
    @fh.create_tree('test-dir')

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
    @fh.move('../../..')
    FileUtils.remove_dir('./test-dir', force = true)
    @fh.move(@start_dir)
  end

  def test_it_makes_a_new_empty_file_in_a_directory
    @fh.create_tree('test-dir')

    @fh.move('test-dir/source/css')
    main = @fh.touch('main.css')
    assert File.exist?(main)
    assert_equal "", File.read('main.css')
    @fh.move('../../..')
    FileUtils.remove_dir('./test-dir', force = true)
    @fh.move(@start_dir)
  end

  def test_it_populates_the_empty_directory
    @fh.create_tree('test-dir')

    @fh.populate_tree('test-dir')
    assert_equal true, File.exist?('test-dir/source/index.markdown')
    assert_equal true, File.exist?('test-dir/source/css/main.css')
    assert_equal true, File.exist?('test-dir/source/pages/about.markdown')
    assert_equal true, File.exist?('test-dir/source/posts/2016-02-20-welcome-to-hyde.markdown')
    FileUtils.remove_dir('./test-dir', force = true)
    @fh.move(@start_dir)
  end
end
