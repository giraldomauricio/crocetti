require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV['RACK_ENV'] = 'test'

require 'app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'lib/templates'
require 'lib/pages'
require 'lib/parser'
require 'models/contents'
require "rexml/document"