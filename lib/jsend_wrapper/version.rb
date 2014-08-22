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
module JsendWrapper
  # This module contains the current version of the gem, but also has a
  # {Bumper} class which will modify this file to increase the version
  module Version
    # The following four lines are generated, so don't mess with them.
    MAJOR = 0
    MINOR = 3
    PATCH = 1
    BUILD = nil

    #@return [String] the current version in the form of +1.2.3.build+
    def self.to_s
      [MAJOR, MINOR, PATCH, BUILD].compact.join '.'
    end

    # A helper class which bumps the version number stored in this file
    class Bumper
      PARTS = %i[major minor patch]
      PATTERN = %r[(\s+)MAJOR = \d+\s+MINOR = \d+\s+PATCH = \d+\s+BUILD = .+]

      #@param filename [String] the file to edit
      #@param part [String] the part of the version to bump. one of major,
      #  minor, or patch
      def initialize(filename=__FILE__, part)
        raise "#{part} not one of #{PARTS}" unless PARTS.include? part
        @filename, @part = filename, part
      end

      # Increase the version number and write it to this file
      def bump
        parts = new_version
        # \1 holds a newline and the indentation from the source
        text = '\1' + ["MAJOR = #{parts[:major]}",
                       "MINOR = #{parts[:minor]}",
                       "PATCH = #{parts[:patch]}",
                       "BUILD = #{parts[:build] || 'nil'}"].join( '\1' )

        out_data = File.read( @filename ).gsub PATTERN, text
        File.open( @filename, 'w' ) { |out| out << out_data }
        puts "Bumped version to #{to_s}"
      end

      #@return [String] What the new version string will be.
      def to_s
        p = new_version
        [p[:major], p[:minor], p[:patch], p[:build]].compact.join ?.
      end

      private

      def new_version
        @vers ||= { major: MAJOR,
                    minor: MINOR,
                    patch: PATCH,
                    build: BUILD }.merge new_parts
      end

      def new_parts
        case @part
        when :major then {
            major: MAJOR + 1,
            minor: 0,
            patch: 0
        }
        when :minor then {
            minor: MINOR + 1,
            patch: 0
        }
        else {
            patch: PATCH + 1
        }
        end
      end
    end
  end
end
