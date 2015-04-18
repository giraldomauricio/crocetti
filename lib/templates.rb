class Templates

  attr_accessor :location

  def set_location(path)
    if(Dir.exists?path)
      @location = path
    end
  end

  def initialize
    @location = nil
    set_location(ENV['TEMPLATES_FOLDER'])
  end

  def get_list
    Dir[@location + '*']
  end

  def template_exists?(name)
    File.exists?(@location + name)
  end

  def load_template(name)
    file = nil
    if(template_exists?(name))
         file = File.open(@location + name, "rb").read
    end
    file
  end

end