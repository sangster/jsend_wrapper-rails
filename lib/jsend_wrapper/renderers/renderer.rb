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
require 'json'

module JsendWrapper
  class Renderer
  protected

    def json_string(obj)
      if obj.respond_to? :to_json
        obj.to_json
      elsif obj.nil?
        'null'
      else
        JSON.dump obj
      end
    end
  end
end
