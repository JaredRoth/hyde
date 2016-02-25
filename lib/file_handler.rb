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
    t       = Time.new
    css_1   = File.read('lib/test1.css')
    css_2   = File.read('lib/test2.css')
    css_3   = File.read('lib/test3.css')
    index   = File.read('lib/index.markdown')
    about   = File.read('lib/about.markdown')
    welcome = File.read('lib/welcome-to-hyde.markdown')
    layout  = File.read('lib/default.html.erb')

    File.write("#{directory}/source/pages/about.markdown", about)
    File.write("#{directory}/source/index.markdown", index)
    File.write("#{directory}/source/css/test1.css", css_1)
    File.write("#{directory}/source/css/test2.css", css_2)
    File.write("#{directory}/source/css/test3.css", css_3)
    File.write("#{directory}/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown", welcome)
    File.write("#{directory}/source/layouts/default.html.erb", layout)
  end

  def copy_source
    FileUtils::mkdir_p "#{directory}/_output/css"
    FileUtils::mkdir_p "#{directory}/_output/pages"
    FileUtils::mkdir_p "#{directory}/_output/posts"

    FileUtils.copy_entry("#{directory}/source", "#{directory}/_output")

    Dir.glob("#{directory}/_output/**/*.{md,markdown}") do |file|
      new_file_ext = file.sub(".md", ".html")
      new_file_ext = file.sub(".markdown", ".html")
      markdown     = File.read(file)
      html         = Kramdown::Document.new(markdown).to_html
      formatted    = inject(html)

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
  fh = FileHandler.new(dir)
  puts fh.directory + '/source'
  fh.create_tree
  fh.populate_tree
  fh.post_template("My Post")
  fh.copy_source
  # FileUtils.remove_dir('test-dir', force = true)
end
# :nocov:
