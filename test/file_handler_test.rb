require 'minitest/autorun'
require 'pry'
require_relative '../lib/file_handler'

class FileHandlerTest < Minitest::Test

  def test_it_navigates_to_the_input_directory
    fh = FileHandler.new
    fh.move('../lib')
    assert_equal "lib", File.basename(Dir.pwd)
    FileUtils.cd('../test')
  end

  def test_it_creates_an_empty_directory
    fh = FileHandler.new
    fh.create('test-dir')

    fh.move('test-dir/output')
    assert_equal 'output', File.basename(Dir.pwd)
    FileUtils.cd('../..')

    fh.move('test-dir/source')
    assert_equal 'source', File.basename(Dir.pwd)
    FileUtils.cd('../..')

    fh.move('test-dir/source/css')
    assert_equal 'css', File.basename(Dir.pwd)
    FileUtils.cd('../../..')

    fh.move('test-dir/source/pages')
    assert_equal 'pages', File.basename(Dir.pwd)
    FileUtils.cd('../../..')

    fh.move('test-dir/source/posts')
    assert_equal 'posts', File.basename(Dir.pwd)
    FileUtils.cd('../../..')
  end

  #create an empty directory in given directory
  #create, inside the new directory, an empty directory called output
  # and a directory called source.
  # inside the source directory, create dir, css, pages, post and the file
  #index.markdown


end
