class Parser

  def extract(tag)
    result = []
    tags =  tag.scan(/<cms:content(.*)\/>/)
    tags.each { |tag| result << tag[0].strip }
    result
  end

end