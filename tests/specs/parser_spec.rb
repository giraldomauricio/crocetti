ENV['RACK_ENV'] = 'test'

require 'app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'lib/parser'
require 'lib/templates'

describe 'Parser processor' do

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
    templates.set_location(Dir.pwd + '/tests/specs/templates/')
    template_file = templates.load_template('template1.html')
    extracted_tags = parser.extract(template_file)
    expect(extracted_tags.size).to eq 3
    expect(extracted_tags[0]).to eq 'header'
  end

end