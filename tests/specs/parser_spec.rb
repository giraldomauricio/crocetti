require File.expand_path '../spec_helper.rb', __FILE__

describe 'Parser processor' do

  def app
    Sinatra::Application
  end

  it 'extracts the tag name' do
    parser = Parser.new
    tag = "<cms:content header/>"
    extracted_tags = parser.extract(tag)
    expect(extracted_tags[0]).to eq 'header'
  end

end

describe 'Parser processor with Templates' do

  it 'extracts the tag name inside a template' do
    parser = Parser.new
    templates = Templates.new
    templates.set_location(Dir.pwd + '/tests/specs/contents/templates/')
    template_file = templates.load_template('template1.html')
    extracted_tags = parser.extract(template_file)
    expect(extracted_tags.size).to eq 3
    expect(extracted_tags[0]).to eq 'header'
  end

end

describe 'Handles the location' do

  it 'then sets and gets the location' do
    parser = Parser.new
    parser.set_location(Dir.pwd + '/tests/specs/contents/site/')
    expect(parser.location).to eq Dir.pwd + '/tests/specs/contents/site/'
  end

  it "then set the location" do
    parser = Parser.new
    parser.set_location ("contents")
    expect(parser.location).to eq "contents"
  end

  it "then there is no location" do
    ENV['CONTENTS_FOLDER'] = 'foo'
    parser = Parser.new
    expect(parser.location).to be_nil
  end

  it "then get the configuration one" do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    expect(parser.location).to eq(ENV['CONTENTS_FOLDER'])
  end

end

describe 'Handles the versions' do

  it 'load the sections' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    sections = parser.load_sections
    puts sections.inspect
    expect(sections.is_a?(Hash)).to eq(true)
  end

  it 'loads a page version' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    version = parser.get_version('section1/subsection1/page1')
    expect(version).to eq('2')
    version = parser.get_version('section1/subsection1/page1/')
    expect(version).to eq('2')
  end

  it 'loads content from version' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    content = parser.get_contents('section1/subsection1/page1')
    expect(content).to include('Some HTML 6')
  end

  it 'cannot load content from version' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    content = parser.get_contents('section1/subsection1/foo')
    expect(content).to be_nil
  end

end

describe 'Load contents' do
  it 'loads content from version' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    parser = Parser.new
    content = parser.get_contents('section1/subsection1/page1')
    expect(content).to include('Some HTML 6')
  end
end


describe 'Performs content changes' do

  it "loads the contents file" do
    parser = Parser.new
    content = parser.load_content_file('section1/subsection1/page1')
    expect(content).not_to be_nil
    expect(content.instance_of?(Content)).to eq(true)
    expect(content.contents.instance_of?(Array)).to eq(true)
    expect(content.contents[2].contents).to include('Some HTML 6')
    expect(content.contents[2].name).to eq('footer')
  end

end