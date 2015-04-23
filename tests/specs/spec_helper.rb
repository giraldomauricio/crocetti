ENV['CODECLIMATE_REPO_TOKEN'] = '83d94b53e25d638f476aac76ed13cc5564750434642d8d2827bad73b290e6c0d'
require "codeclimate-test-reporter"
#CodeClimate::TestReporter.start

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../../app', __FILE__

require 'rspec'
require 'rack/test'
require 'templates'
require 'pages'
require 'parser'
require File.expand_path('../../../models/contents', __FILE__)
require File.expand_path('../../../models/content', __FILE__)
require "rexml/document"
require 'cms'