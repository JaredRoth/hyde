require 'fileutils'
require 'kramdown'
require 'erb'

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
    FileUtils::mkdir_p "#{directory}/source/layouts"
  end

  def populate_tree(directory)
    touch("#{directory}/source/index.markdown")
    touch("#{directory}/source/css/main.css")
    touch("#{directory}/source/pages/about.markdown")
    touch("#{directory}/source/layouts/default.html.erb")
    t = Time.new
    touch("#{directory}/source/posts/#{t.strftime("%F")}-welcome-to-hyde.markdown")
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
  fh.post_template(dir, "My Post")
  fh.copy_source(dir)

  # FileUtils.remove_dir('test-dir', force = true)
end
# :nocov:
