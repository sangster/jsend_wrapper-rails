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
require 'jsend_wrapper/renderers/error_renderer'

RSpec.describe JsendWrapper::ErrorRenderer do
  subject(:renderer) { JsendWrapper::ErrorRenderer.new message, optional }
  let(:message) { 'BOOM!' }
  let(:optional) { Hash.new }


  describe '#message' do
    it 'can be accessed' do
      expect( renderer.message ).to eq message
    end

    context 'responds to #to_s' do
      let(:message) { double to_s: expected_string }
      let(:expected_string) { 'Some custom string' }

      it 'uses the #to_s content' do
        expect( renderer.message ).to eq expected_string
      end
    end
  end


  describe '#code' do
    let(:code) { 1234 }
    let(:optional) { {code: code} }

    it 'can be accessed' do
      expect( renderer.code ).to eq code
    end

    it 'is marked as present' do
      expect( renderer.code? ).to eq true
    end

    context 'responds to #to_i' do
      let(:code) { double to_i: expected_code }
      let(:expected_code) { 56789 }

      it 'uses the #to_i content' do
        expect( renderer.code ).to eq expected_code
      end
    end

    context 'does not respond to #to_i' do
      let(:code) { double }

      it 'should raise an error' do
        expect { renderer }.to raise_error # error raised by #initialize
      end
    end
  end


  describe '#data' do
    let(:data) { {dog: 'bark', cat: 'meow'} }
    let(:optional) { {data: data} }

    it 'can be accessed' do
      expect( renderer.data ).to eq data
    end

    it 'is marked as present' do
      expect( renderer.data? ).to eq true
    end
  end


  describe '#to_s and #to_h' do
    context 'with no optional elements' do
      it 'only has "status" and "message"' do
        expect( renderer.to_s ).to eq '{"status":"error","message":"BOOM!"}'
        expect( renderer.to_h ).to eq( status: 'error', message: 'BOOM!' )
      end
    end

    context 'with an optional code element' do
      let(:optional) { {code: 4446} }

      it 'includes the code element' do
        expect( renderer.to_s ).to eq '{"status":"error","message":"BOOM!","code":4446}'
        expect( renderer.to_h ).to eq( status: 'error', message: 'BOOM!', code: 4446 )
      end
    end

    context 'with an optional data element' do
      let(:optional) { {data: {moo: 'cow'}} }

      it 'also includes the data element' do
        expect( renderer.to_s ).to eq '{"status":"error","message":"BOOM!","data":{"moo":"cow"}}'
        expect( renderer.to_h ).to eq( status: 'error', message: 'BOOM!', data: {moo: 'cow'} )
      end

      context 'that is nil' do
        let(:optional) { {data: nil} }

        it 'includes the data element' do
          expect( renderer.to_s ).to eq '{"status":"error","message":"BOOM!","data":null}'
          expect( renderer.to_h ).to eq( status: 'error', message: 'BOOM!', data: nil )
        end
      end
    end

    context 'with both optional elements (code and data)' do
      let(:optional) { {code: 4321, data: {moo: 'cow'}} }

      it 'also includes the data element' do
        expect( renderer.to_s ).to eq '{"status":"error","message":"BOOM!","code":4321,"data":{"moo":"cow"}}'
        expect( renderer.to_h ).to eq( status: 'error', message: 'BOOM!', code:4321, data: {moo: 'cow'} )
      end
    end
  end

  describe 'optional hash missing' do
    subject(:renderer) { JsendWrapper::ErrorRenderer }
    let(:message) { 'BOOM!' }

    it { expect{ renderer.new message }.to_not raise_error }
  end
end
