require 'parser'
require 'fileutils'

class Page

  attr_accessor :path, :current, :versions

  def initialize (path)
    @path = path
    parser = Parser.new
    @current = parser.get_version(path)
    @versions = []
    get_versions(path)
  end

  def get_containing_folder
    path_array = @path.split('/')
    path_array[0..-2].join('/')
  end

  def clone_page(path, new_name="clone")
    if(!Dir.exists?(get_folder_path(new_name)))
      FileUtils.mkdir(get_folder_path(new_name))
      FileUtils.cp_r(ENV['CONTENTS_FOLDER'] + path + '/.' ,get_folder_path(new_name))
    end
  end

  def get_folder_path(path)
    ENV['CONTENTS_FOLDER'] + get_containing_folder + '/' + path
  end

  def get_versions(path)
    if(Dir.exists?(ENV['CONTENTS_FOLDER'] + path))
      Dir.foreach(ENV['CONTENTS_FOLDER'] + path) do |entry|
        next if (entry == '..' || entry == '.')
        if (File.file?(ENV['CONTENTS_FOLDER'] + path + '/' + entry) && entry.include?('.xml') && entry.include?('version'))
          @versions << entry.gsub('version','').gsub('.xml','')
        else
        end
      end
    end
  end

end