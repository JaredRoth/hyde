require_relative 'test_helper'
require_relative '../lib/file_handler'

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
    @fh.create_tree
    @fh.populate_tree

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

  def test_it_creates_a_post_template
    t = Time.new
    @fh.create_tree
    @fh.populate_tree
    @fh.post_template("Juicy Post")
    assert_equal true, File.exist?("test-dir/source/posts/#{t.strftime("%F")}-juicy-post.markdown")
    assert_equal "# Juicy Post\n\nyour content here",
    File.read("test-dir/source/posts/#{t.strftime("%F")}-juicy-post.markdown")
  end

  def test_it_creates_an_empty_directory
    @fh.create_tree

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

    @fh.move('test-dir/source/layouts')
    assert_equal 'layouts', File.basename(Dir.pwd)
    @fh.move('../../..')
  end

  def test_it_populates_the_empty_directory
    t = Time.new
    @fh.create_tree

    @fh.populate_tree
    assert_equal true, File.exist?('test-dir/source/index.markdown')
    assert_equal true, File.exist?('test-dir/source/css/test1.css')
    assert_equal true, File.exist?('test-dir/source/css/test2.css')
    assert_equal true, File.exist?('test-dir/source/css/test3.css')
    assert_equal true, File.exist?('test-dir/source/pages/about.markdown')
    assert_equal true, File.exist?('test-dir/source/layouts/default.html.erb')
    assert_equal true, File.exist?("test-dir/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown")
    assert_equal "<html>
  <head><title>Our Site</title>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"css/test2.css\">
    <link rel=\"stylesheet\" type=\"text/css\" href=\"../css/test2.css\">
  </head>
    <body>
    <%= html %>
    </body>
</html>
", File.read('test-dir/source/layouts/default.html.erb')
  end

  def test_it_copies_source_contents_into_output
    t = Time.new
    @fh.create_tree
    @fh.populate_tree
    @fh.copy_source
    assert_equal true, File.exist?('test-dir/_output/index.html')
    assert_equal true, File.exist?('test-dir/source/css/test1.css')
    assert_equal true, File.exist?('test-dir/source/css/test2.css')
    assert_equal true, File.exist?('test-dir/source/css/test3.css')
    assert_equal true, File.exist?('test-dir/_output/pages/about.html')
    assert_equal true, File.exist?("test-dir/_output/posts/#{t.strftime("%F")}-welcome-to-hyde.html")
  end
end
