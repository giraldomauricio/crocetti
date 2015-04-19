ENV['RACK_ENV'] = 'test'

require 'app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'lib/cms'

describe 'CMS Operation' do

  it "load the template and replaces the content" do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    ENV['TEMPLATES_FOLDER'] = Dir.pwd + '/tests/specs/contents/templates/'
    cms = CMS.new
    content = cms.load('section1/subsection1/page1')
    expect(content).to include('Title of the document')
    expect(content).to include('Some HTML 4')
    expect(content).to include('Some HTML 6')
  end

end