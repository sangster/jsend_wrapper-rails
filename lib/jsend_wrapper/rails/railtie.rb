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
require 'rails/railtie'

module JsendWrapper
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'jsend_wrapper-rails.initialization' do
        if JsendWrapper::Rails.jbuilder_available?
          JsendWrapper::Rails.install_template_handler
        end
        JsendWrapper::Rails.install_render_option
      end
    end


    #@return [Boolean] true if the {Jbuilder} gem is available
    def self.jbuilder_available?
      require 'jbuilder'
      true
    rescue LoadError
      $stderr.puts 'WARN: Please include the "jbuilder" gem for .jsend templates'
      false
    end

    # Install a "template handler" for .jsend view files. These files will be
    # processed with {Jbuilder}, just like .jbuilder view files, but the result
    # will be wrapped in a "success" JSend wrapper.
    def self.install_template_handler
      require 'jsend_wrapper/rails/template_handler'

      ActionView::Template.register_template_handler \
        :jsend, JsendWrapper::Rails::TemplateHandler
    end


    # Adds the "jsend:" option to {ActiveController::Base#render}
    def self.install_render_option
      require 'jsend_wrapper/rails/render_option'

      ActionController::Renderers.add :jsend do |value, _|
        self.content_type ||= Mime::JSON
        RenderOption.new(value).render
      end
    end
  end
end
