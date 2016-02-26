require 'fileutils'
require 'kramdown'
require 'erb'
require 'listen'
require 'pry'

class FileHandler

  def initialize(directory)
    @directory = directory
  end

  def move(directory)
    FileUtils.cd(directory)
  end

  def inject(html)
    ERB.new(File.read("#{@directory}/source/layouts/default.html.erb")).result(binding)
  end
  
end
