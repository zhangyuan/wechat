ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
require 'bundler/setup'

Bundler.require

require "faraday"
require "multi_json"

require 'webmock/rspec'
