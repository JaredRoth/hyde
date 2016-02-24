require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/file_handler'

class FileHandlerTest < Minitest::Test
  DIR = Dir.pwd

  def setup
    @fh = FileHandler.new
  end

  def teardown
    @fh.move(DIR)
    FileUtils.remove_dir('test-dir', force = true)
  end

  def test_it_navigates_to_the_input_directory
    puts Dir.pwd
    @fh.move('./lib')
    assert_equal "lib", File.basename(Dir.pwd)
  end

  def test_it_recognizes_tilde_properly
    @fh.create_tree("#{Dir.home}/test-dir")
    @fh.move("#{Dir.home}/test-dir")

    assert_equal "#{Dir.home}/test-dir", Dir.pwd
    @fh.move("../")
  end

  def test_it_creates_an_empty_directory
    @fh.create_tree('test-dir')

    @fh.move('test-dir/_output')
    assert_equal '_output', File.basename(Dir.pwd)
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
  end

  def test_it_makes_a_new_empty_file_in_a_directory
    @fh.create_tree('test-dir')

    @fh.move('test-dir/source/css')
    main = @fh.touch('main.css')
    assert File.exist?(main)
    assert_equal "", File.read('main.css')
    @fh.move('../../..')
  end

  def test_it_populates_the_empty_directory
    @fh.create_tree('test-dir')

    @fh.populate_tree('test-dir')
    assert_equal true, File.exist?('test-dir/source/index.markdown')
    assert_equal true, File.exist?('test-dir/source/css/main.css')
    assert_equal true, File.exist?('test-dir/source/pages/about.markdown')
    assert_equal true, File.exist?('test-dir/source/posts/2016-02-20-welcome-to-hyde.markdown')
  end

  def test_it_copies_source_contents_into_output
    @fh.create_tree('test-dir')
    @fh.populate_tree('test-dir')
    @fh.copy_source('test-dir')
    assert_equal true, File.exist?('test-dir/_output/index.markdown')
    assert_equal true, File.exist?('test-dir/_output/css/main.css')
    assert_equal true, File.exist?('test-dir/_output/pages/about.markdown')
    assert_equal true, File.exist?('test-dir/_output/posts/2016-02-20-welcome-to-hyde.markdown')
  end
end
