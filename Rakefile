# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'jeweler'

require_relative 'lib/jsend_wrapper-rails'
require_relative 'lib/jsend_wrapper/version'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

Jeweler::Tasks.new do |gem|
  gem.name = 'jsend_wrapper-rails'
  gem.version = GtfsReader::Version.to_s
  gem.homepage = 'http://github.com/sangster/jsend_wrapper-rails'
  gem.license = 'GPL 3'
  gem.summary = 'Wraps JSON in a JSend envelope'
  gem.description = <<-EOF.strip.gsub /\s+/, ' '
    TODO Some description here.
  EOF
  gem.email = 'jon@ertt.ca'
  gem.authors = ['Jon Sangster']

  gem.files = Dir['{lib}/**/*', 'Rakefile', 'README.md', 'LICENSE']
end

Jeweler::RubygemsDotOrgTasks.new

task :pry do
  exec 'pry --gem'
end

task bump: ['bump:patch']
namespace :bump do
  [:major, :minor, :patch].each do |part|
    bumper = JsendWrapper::Version::Bumper.new part
    desc "Bump the version to #{bumper}"
    task(part) { bumper.bump }
  end
end

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec
task default: :spec
