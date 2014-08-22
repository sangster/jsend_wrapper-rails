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
require 'jsend_wrapper/rails/render_option'

RSpec.describe JsendWrapper::RenderOption do

  let(:option) { JsendWrapper::RenderOption.new object }

  describe '#render' do
    subject(:json) { option.render }


    describe 'type: success' do
      describe 'without hash' do
        context 'with a simple object that responds to #to_json' do
          let (:object) { double to_json: '{"dog":"woof"}' }

          it { expect( json ).to eq '{"status":"success","data":{"dog":"woof"}}' }
        end

        context 'with a string' do
          let(:object) { %[how 'are' "you"?] }

          it { expect( json ).to eq %[{"status":"success","data":"how 'are' \\"you\\"?"}] }
        end
      end

      describe 'with hash' do
        context 'with a simple object that responds to #to_json' do
          let (:object) { {success: double(to_json: '{"dog":"woof"}')} }

          it { expect( json ).to eq '{"status":"success","data":{"dog":"woof"}}' }
        end

        context 'with a string' do
          let(:object) { {success: %[how 'are' "you"?]} }

          it { expect( json ).to eq %[{"status":"success","data":"how 'are' \\"you\\"?"}] }
        end
      end
    end


    describe 'type: fail' do
      context 'with a simple object that responds to #to_json' do
        let (:object) { {fail: double(to_json: '{"dog":"woof"}')} }

        it { expect( json ).to eq '{"status":"fail","data":{"dog":"woof"}}' }
      end

      context 'with a string' do
        let(:object) { {fail: %[how 'are' "you"?]} }

        it { expect( json ).to eq %[{"status":"fail","data":"how 'are' \\"you\\"?"}] }
      end
    end


    describe 'type: error' do
      context 'with no optional elements' do
        let(:object) { {error: 'hi'} }

        it{ expect( json ).to eq '{"status":"error","message":"hi"}' }
      end

      context 'with a code' do
        let(:object) { {error: 'hi', code: 123} }

        it { expect( json ).to eq '{"status":"error","message":"hi","code":123}' }

        context 'that is invalid (not a number)' do
          let(:object) { {error: 'hi', code: {some: :hash}} }

          it { expect { json }.to raise_error }
        end
      end

      context 'with data' do
        let(:object) { {error: 'hi', data: {some: 'data'}} }

        it { expect( json ).to eq '{"status":"error","message":"hi","data":{"some":"data"}}' }
      end
    end


    describe 'type: unknown' do
      context 'with none of the required keys (success, fail, error)' do
        let(:object) { {code: 123, data: {some: 'data'}} }

        it { expect { json }.to raise_error }
      end
    end
  end
end
