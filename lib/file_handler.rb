require 'fileutils'
require 'kramdown'
require 'erb'
require 'listen'
require 'pry'

class FileHandler
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def move(directory)
    FileUtils.cd(directory)
  end

  def inject(html)
    ERB.new(File.read("#{directory}/source/layouts/default.html.erb")).result(binding)
  end

  def create_tree
    FileUtils::mkdir_p "#{directory}/_output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
    FileUtils::mkdir_p "#{directory}/source/layouts"
  end

  def populate_tree
    touch("#{directory}/source/index.markdown")
    touch("#{directory}/source/css/main.css")
    touch("#{directory}/source/pages/about.markdown")
    touch("#{directory}/source/layouts/default.html.erb")
    File.write("#{directory}/source/layouts/default.html.erb",
    "<html>\n  <head><title>Our Site</title></head>\n  " +
    "<body>\n    <%= html %>\n  </body>\n</html>")

  def populate_tree
    # potentially collapse into array
    css_1 = File.read('lib/test1.css')
    css_2 = File.read('lib/test2.css')
    css_3 = File.read('lib/test3.css')
    index = File.read('lib/index.markdown')
    about = File.read('lib/about.markdown')
    post_welcome = File.read('lib/welcome-to-hyde.markdown')
    File.write(("#{directory}/source/pages/about.markdown"), about)
    File.write(("#{directory}/source/index.markdown"), index)
    File.write(("#{directory}/source/css/test1.css"), css_1)
    File.write(("#{directory}/source/css/test2.css"), css_2)
    File.write(("#{directory}/source/css/test3.css"), css_3)
    t = Time.new
    File.write(("#{directory}/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown"), post_welcome)
  end

  def copy_source
    FileUtils::mkdir_p "#{directory}/_output/css"
    FileUtils::mkdir_p "#{directory}/_output/pages"
    FileUtils::mkdir_p "#{directory}/_output/posts"

    FileUtils.copy_entry("#{directory}/source", "#{directory}/_output")

    Dir.glob("#{directory}/_output/**/*.{md,markdown}") do |file|
      new_file_ext = file.sub(".md", ".html")
      new_file_ext = file.sub(".markdown", ".html")
      markdown = File.read(file)
      html = Kramdown::Document.new(markdown).to_html
      formatted = inject(html)
      File.write(new_file_ext, formatted)
      File.delete(file)
    end
  end

  def post_template(title)
    t = Time.new
    filename = "#{directory}/source/posts/#{t.strftime("%F")}-#{title.downcase.gsub(" ", "-")}.markdown"
    File.write(filename, "# #{title}\n\nyour content here")
  end
end

# :nocov:
if __FILE__ == $0
  dir = "test-dir"
<<<<<<< HEAD
  fh = FileHandler.new(dir)
  puts fh.directory + '/source'
  # fh.create_tree
  # fh.populate_tree
  # fh.post_template("My Post")
  # fh.copy_source
=======
  fh.create_tree(dir)
  fh.populate_tree(dir)
  #running the next line throws a wrench-
  #welcome-to-hyde appears in output, but is blank in source.
  #I am currently feeling a little confused about how 'post' is supposed to be used
  fh.post_template(dir, "My Post")
  fh.copy_source(dir)
>>>>>>> 5378b85cbc6f2979b33926a47a1e4e0ba4327bb6

  listener = Listen.to(dir + '/source/posts') do |modified, added, removed|
    puts "modified absolute path: #{modified}"
    puts "added absolute path: #{added}"
    puts "removed absolute path: #{removed}"
    fh.copy_source
  end
  listener.start
  listener.pause
  fh.post_template("New Post")
  listener.start
  listener.stop
  # FileUtils.remove_dir('test-dir', force = true)
end
# :nocov:
