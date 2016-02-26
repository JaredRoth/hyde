require_relative 'test_helper'
require_relative '../lib/file_handler'
require_relative '../lib/builder'

class FileHandlerTest < Minitest::Test
  DIR = Dir.pwd

  def setup
    @fh = FileHandler.new('test-dir')
  end

  def teardown
    @fh.move(DIR)
    FileUtils.remove_dir('test-dir', force = true)
  end

  def test_it_navigates_to_the_input_directory
    @fh.move('./lib')
    assert_equal "lib", File.basename(Dir.pwd)
  end

  def test_it_injects_html
    hyde = Builder.new('test-dir')
    hyde.create_tree
    hyde.populate_tree

    assert_equal "<html>
  <head><title>Our Site</title>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"css/test2.css\">
    <link rel=\"stylesheet\" type=\"text/css\" href=\"../css/test2.css\">
  </head>
    <body>
    Some words
    </body>
</html>
",
    @fh.inject("Some words")
  end
end
