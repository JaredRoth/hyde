require 'fileutils'
require "kramdown"
require 'pry'

class FileHandler

  def move(directory)
    FileUtils.cd(directory)
  end

  def touch(file_name)
    File.new(file_name, "w+")
  end

  def create_tree(directory)
    FileUtils::mkdir_p "#{directory}/_output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
  end

  def populate_tree(directory)
    # potentially collapse into array
    css_1 = File.read('test1.css')
    css_2 = File.read('test2.css')
    css_3 = File.read('test3.css')
    index = File.read('index.markdown')
    about = File.read('about.markdown')
    post_welcome = File.read('welcome-to-hyde.markdown')
    #touch("#{directory}/source/index.markdown")
    #touch("#{directory}/source/css/main.css")
    #touch("#{directory}/source/pages/about.markdown")
    File.write(("#{directory}/source/pages/about.markdown"), about)
    File.write(("#{directory}/source/index.markdown"), index)
    File.write(("#{directory}/source/css/test1.css"), css_1)
    File.write(("#{directory}/source/css/test2.css"), css_2)
    File.write(("#{directory}/source/css/test3.css"), css_3)
    t = Time.new
    #touch("#{directory}/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown")
    File.write(("#{directory}/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown"), post_welcome)
  end

  def copy_source(directory)
    FileUtils::mkdir_p "#{directory}/_output/css"
    FileUtils::mkdir_p "#{directory}/_output/pages"
    FileUtils::mkdir_p "#{directory}/_output/posts"

    FileUtils.copy_entry("#{directory}/source", "#{directory}/_output")

    Dir.glob("#{directory}/_output/**/*.{md,markdown}") do |file|
      new_filename = file.sub(".md", ".html")
      new_filename = file.sub(".markdown", ".html")
      markdown = File.read(file)
      html = Kramdown::Document.new(markdown).to_html
      File.write(new_filename, html)
      File.delete(file)
    end
  end

  def post_template(directory, title)
    t = Time.new
    filename = "#{directory}/source/posts/#{t.strftime("%F")}-#{title.downcase.gsub(" ", "-")}.markdown"
    File.write(filename, "# #{title}\n\nyour content here...")
  end
end

# :nocov:
if __FILE__ == $0
  fh = FileHandler.new
  dir = "test-dir"
  fh.create_tree(dir)
  fh.populate_tree(dir)
  #running the next line throws a wrench-
  #welcome-to-hyde appears in output, but is blank in source.
  #I am currently feeling a little confused about how 'post' is supposed to be used
  fh.post_template(dir, "My Post")
  fh.copy_source(dir)

  # FileUtils.remove_dir('test-dir', force = true)
end
# :nocov:
