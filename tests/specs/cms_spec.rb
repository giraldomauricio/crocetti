require File.expand_path '../spec_helper.rb', __FILE__

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