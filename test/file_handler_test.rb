require 'minitest/autorun'
require 'pry'
require_relative '../lib/file_handler'

class FileHandlerTest < Minitest::Test

  def test_it_navigates_to_the_input_directory
    fh = FileHandler.new
    fh.move('/bin')
    assert_equal "/bin" ,FileUtils.pwd
  end

  def test_it_creates_an_empty_directory
    fh = FileHandler.new
    # fh.move('/test-dir')
    fh.create('/test-dir')
    fh.move('/test-dir/source/posts')
    assert_equal '/posts', FileUtils.pwd
  end
  
  #create an empty directory in given directory
  #create, inside the new directory, an empty directory called output
  # and a directory called source.
  # inside the source directory, create dir, css, pages, post and the file
  #index.markdown


end
