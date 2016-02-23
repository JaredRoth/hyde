require 'pry'
require 'fileutils'

class FileHandler

  def move(path)
    FileUtils.cd(path)
  end

  def create(directory)
    binding.pry
    FileUtils::mkdir_p "#{directory}/output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
  end

end
