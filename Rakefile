# jsend_wrapper-rails: Wrap JSON views in JSend containers
# Copyright (C) 2014 Jon Sangster
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
require 'rubygems'
require 'bundler'
require 'rake'
require 'jeweler'

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
  gem.version = JsendWrapper::Version.to_s
  gem.homepage = 'http://github.com/sangster/jsend_wrapper-rails'
  gem.license = 'GPL 3'
  gem.summary = 'Wraps JSON in a JSend envelope'
  gem.description = <<-EOF.strip.gsub /\s+/, ' '
    { "status": "success", "data": "Wraps JSON views in JSend containers" }
  EOF
  gem.email = 'jon@ertt.ca'
  gem.authors = ['Jon Sangster']

  gem.files = Dir['{lib}/**/*', 'Rakefile', 'README.md', 'LICENSE']
  gem.files.exclude 'lib/jsend_wrapper/version.rb'
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
