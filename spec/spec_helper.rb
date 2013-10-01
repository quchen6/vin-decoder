require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join "spec", "vcr_cassettes"
  c.hook_into :fakeweb
end