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
require 'jsend_wrapper/renderers/success_renderer'

RSpec.describe JsendWrapper::SuccessRenderer do
  subject(:renderer) { JsendWrapper::SuccessRenderer.new data }

  describe '#data' do
    let(:data) { 12345 }

    it 'can be accessed' do
      expect( renderer.data ).to eq data
    end
  end

  describe '#call' do
    context 'with nil' do
      let(:data) { nil }

      it 'should convert nil to null' do
        expect( renderer.call ).to eq '{"status":"success","data":null}'
      end
    end

    context 'with a number' do
      let(:data) { 1234 }

      it 'should print unquoted' do
        expect( renderer.call ).to eq '{"status":"success","data":1234}'
      end
    end

    context 'with a hash' do
      let(:data) { {dog: 'bark', cat: {happy: 'purr', mad: 'hiss'}} }

      it 'should convert entire hierarchy' do
        expect( renderer.call ).to eq '{"status":"success","data":{"dog":"bark","cat":{"happy":"purr","mad":"hiss"}}}'
      end
    end

    context 'with an array' do
      let(:data) { [1, 2, 3, 4] }

      it 'should convert to a JSON array' do
        expect( renderer.call ).to eq '{"status":"success","data":[1,2,3,4]}'
      end
    end
  end
end
