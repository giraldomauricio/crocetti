ENV['RACK_ENV'] = 'test'

require 'app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'lib/pages'

describe 'Pages Operation' do

  it "creates a page object of an existing page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/page1')
    expect(page.current).to eq('2')
    expect(page.path).to eq('section1/subsection1/page1')
    expect(page.versions).to eq(["1","2"])

  end

  it "creates a page object of a non existing page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/foo')
    expect(page.current).to eq(nil)
    expect(page.path).to eq('section1/subsection1/foo')
    expect(page.versions).to eq([])

  end

  it 'gets the parent folder' do

    page = Page.new('/foo/bar/doh')
    expect(page.get_containing_folder).to eq('/foo/bar')

  end

  it "clones a page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/page1')

    page.clone_page('section1/subsection1/page1','new_page')

    page = Page.new('section1/subsection1/new_page')

    expect(page.current).to eq('2')
    expect(page.path).to eq('section1/subsection1/new_page')
    expect(page.versions).to eq(["1","2"])

    FileUtils.rm_rf(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/new_page')

  end

end