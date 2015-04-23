require 'parser'
require 'fileutils'
require 'logger'

class Page

  attr_accessor :path, :current, :versions, :content

  def initialize (path)
    @log = Logger.new(STDOUT)
    @log.info("Page - Initialize")
    @path = path
    parser = Parser.new
    @current = parser.get_version(path)
    @versions = []
    get_versions(path)
    if (@current)
      current_content_file = ENV['CONTENTS_FOLDER'] + path + '/version' + @current + '.xml'
      if (File.exists?(current_content_file))
        @content = File.open(current_content_file,'rb').read
      end
    end
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

  def save_page
    new_version = @current.to_i
    new_version += 1
    @current = new_version.to_s
    new_file = ENV['CONTENTS_FOLDER'] + @path + '/version' + @current + '.xml'
    @log.info("Page - Save File:#{new_file}")
    File.open(new_file, 'w') { |file| file.write(@content) }
    get_versions(@path)
  end

  def get_folder_path(path)
    ENV['CONTENTS_FOLDER'] + get_containing_folder + '/' + path
  end

  def get_versions(path)
    @versions = []
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