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
require 'active_support/core_ext/hash/slice'
require 'jsend_wrapper/renderers'

module JsendWrapper
  # Parses the "render jsend: {...}" command. Valid forms:
  class RenderOption
    VALID_TYPES   = [:success, :fail, :error]
    VALID_OPTIONS = [:data, :code, :message]
    VALID_KEYS    = VALID_TYPES + VALID_OPTIONS

    #@param obj [Hash,Object] Examples:
    # render jsend: @object
    # render jsend: {success: @object}
    # render jsend: {fail: @object}
    # render jsend: {error: @object}
    # render jsend: {error: @object, code: 123}
    # render jsend: {error: @object, data: @another_object}
    # render jsend: {error: @object, code: 123, data: @another_object}
    def initialize(obj)
      @hash = normalize obj
    end


    #@return [String] A string containing the rendered JSON
    def render
      renderer.to_s
    end


    #@return [Renderer] One of {SuccessRenderer}, {FailRenderer}, or
    #  {ErrorRenderer}
    def renderer
      @renderer ||=
        if @hash.key? :success
          SuccessRenderer.new @hash[:success]
        elsif @hash.key? :fail
          FailRenderer.new @hash[:fail]
        elsif @hash.key? :error
          ErrorRenderer.new @hash[:error], @hash.slice(:code, :data)
        else
          raise 'render jsend:{...} must include "success:", "fail:", or "error:"'
        end
    end


private


    def normalize(obj)
      if Hash === obj && jsend_hash?(obj)
        obj
      else
        {success: obj}
      end
    end


    def jsend_hash?(hash)
      hash.keys.all? { |key| VALID_KEYS.include? key }
    end
  end
end
