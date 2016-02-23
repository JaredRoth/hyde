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
    FileUtils::mkdir_p "#{directory}/output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
  end

  def populate_tree(directory)
    move("#{directory}/source")
    touch('index.markdown')
    move("../css")
    touch('main.css')
    move("../pages")
    touch('about.markdown')
    move("../posts")
    touch('2016-02-20-welcome-to-hyde.markdown')
  end
end
