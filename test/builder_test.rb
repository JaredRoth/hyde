require_relative 'test_helper'
require_relative '../lib/builder'

class BuilderTest < Minitest::Test
  DIR = Dir.pwd

  def setup
    @dir = 'test-dir'
    @hyde = Builder.new(@dir)
  end

  def teardown
    FileHandler.new(@dir).move(DIR)
    FileUtils.remove_dir(@dir, force = true)
  end

  def test_it_creates_an_empty_directory
    fh = FileHandler.new(@dir)
    @hyde.create_tree

    fh.move('test-dir/_output')
    assert_equal '_output', File.basename(Dir.pwd)
    fh.move('../..')

    fh.move('test-dir/source')
    assert_equal 'source', File.basename(Dir.pwd)
    fh.move('../..')

    fh.move('test-dir/source/css')
    assert_equal 'css', File.basename(Dir.pwd)
    fh.move('../../..')

    fh.move('test-dir/source/pages')
    assert_equal 'pages', File.basename(Dir.pwd)
    fh.move('../../..')

    fh.move('test-dir/source/posts')
    assert_equal 'posts', File.basename(Dir.pwd)
    fh.move('../../..')

    fh.move('test-dir/source/layouts')
    assert_equal 'layouts', File.basename(Dir.pwd)
    fh.move('../../..')
  end

  def test_it_creates_a_post_template
    t = Time.new
    @hyde.create_tree
    @hyde.populate_tree
    @hyde.create_post("Juicy Post")
    assert_equal true, File.exist?("test-dir/source/posts/#{t.strftime("%F")}-juicy-post.markdown")
    assert_equal "# Juicy Post\n\nyour content here",
    File.read("test-dir/source/posts/#{t.strftime("%F")}-juicy-post.markdown")
  end

  def test_it_populates_the_empty_directory
    t = Time.new
    @hyde.create_tree

    @hyde.populate_tree
    assert_equal true, File.exist?('test-dir/source/index.markdown')
    assert_equal true, File.exist?('test-dir/source/css/test2.css')
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
    @hyde.create_tree
    @hyde.populate_tree
    @hyde.copy_source
    assert_equal true, File.exist?('test-dir/_output/index.html')
    assert_equal true, File.exist?('test-dir/source/css/test2.css')
    assert_equal true, File.exist?('test-dir/_output/pages/about.html')
    assert_equal true, File.exist?("test-dir/_output/posts/#{t.strftime("%F")}-welcome-to-hyde.html")
  end

end
