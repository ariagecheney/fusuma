require 'spec_helper'
module Fusuma
  describe 'Device' do
    describe '.name' do
      context 'with no tap to click device (like a bluetooth apple trackpad)' do
        let(:apple_bluetooth_keyboard_log) do
          File.open(
            'spec/lib/libinput-list-devices_apple_bluetooth_keyboard.txt'
          )
        end
        it 'should return array' do
          allow(Open3).to receive(:popen3).with('libinput-list-devices')
            .and_return(apple_bluetooth_keyboard_log)
          expect(Device.names.class).to eq Array
        end

        it 'should return correct devices' do
          allow(Open3).to receive(:popen3).with('libinput-list-devices')
            .and_return(apple_bluetooth_keyboard_log)
          expect(Device.names).to eq %w(event8 event9)
        end
      end

      context 'when no devices' do
        let(:unavailable_log) do
          File.open(
            'spec/lib/libinput-list-devices_unavailable.txt'
          )
        end

        it 'should failed with exit' do
          allow(Open3).to receive(:popen3).with('libinput-list-devices')
            .and_return(unavailable_log)
          expect { Device.names }.to raise_error(SystemExit)
        end

        it 'should output with logger' do
          allow(Open3).to receive(:popen3).with('libinput-list-devices')
            .and_return(unavailable_log)
          expect(MultiLogger).to receive(:error)
          Device.names
        end
      end
    end
  end
end
