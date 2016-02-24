require 'pry'
require 'fileutils'

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
    touch("#{directory}/source/index.markdown")
    touch("#{directory}/source/css/main.css")
    touch("#{directory}/source/pages/about.markdown")
    touch("#{directory}/source/posts/2016-02-20-welcome-to-hyde.markdown")
  end

  def copy_source(directory)
    FileUtils::mkdir_p "#{directory}/_output/css"
    FileUtils::mkdir_p "#{directory}/_output/pages"
    FileUtils::mkdir_p "#{directory}/_output/posts"

    FileUtils.copy_entry("#{directory}/source", "#{directory}/_output")


    Dir.glob("#{directory}/_output/**/*.{md,markdown}") do |file|
      # use kramdown
      # delete markdown
    end
  end
end

if __FILE__ == $0
  fh = FileHandler.new
  dir = "test-dir"
  fh.create_tree(dir)
  fh.populate_tree(dir)
  fh.copy_source(dir)
  # FileUtils.remove_dir('test-dir', force = true)
end
