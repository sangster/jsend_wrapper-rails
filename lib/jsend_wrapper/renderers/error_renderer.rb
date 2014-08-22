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
require 'jsend_wrapper/renderers/renderer'

module JsendWrapper
  # Wraps the given message in a JSend Error. JSend Errors have two required
  # elements (status, message) and two optional elements (code, data).
  class ErrorRenderer < Renderer
    attr_reader :message, :has_code, :code, :has_data, :data

    alias_method :code?, :has_code
    alias_method :data?, :has_data

    #@param message [#to_s]
    #@param optional [Hash] the optional elements
    #@option optional [#to_i] :code a numeric code representing the error
    #@option optional [Object] :data a generic container for any other
    #  information about the error
    def initialize(message, optional)
      @message  = message.to_s
      @has_code = optional.key? :code
      @has_data = optional.key? :data

      @code = parse_code optional[:code] if code?
      @data = optional[:data]            if data?
    end


    #@return [String] the rendered JSON
    def call
      %[{"status":"error","message":#{message.inspect}#{optional}}]
    end


  private


    def parse_code(code)
      raise '"code" must respond to #to_i' unless code.respond_to? :to_i
      code.to_i
    end


    def optional
      ''.tap do |json|
        json << ',"code":' << code.to_s         if code?
        json << ',"data":' << json_string(data) if data?
      end
    end
  end
end
