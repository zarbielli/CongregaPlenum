# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

# rubocop:disable Metrics/BlockLength
RSpec.describe CongregaPlenum::HttpAdapter do
  subject(:adapter) { described_class.new(configuration: configuration) }

  let(:logger) { Logger.new(StringIO.new) }
  let(:configuration) do
    CongregaPlenum::Factories.configuration(timeout: 5, logger: logger)
  end
  let(:uri) { URI('https://dadosabertos.camara.leg.br/api/v2/deputados') }

  describe '#get' do
    it 'configura tempo limite e headers apropriados' do
      http_double = instance_double(Net::HTTP)
      request_double = instance_double(Net::HTTP::Get)
      response = instance_double(Net::HTTPResponse)

      allow(Net::HTTP).to receive(:new).and_return(http_double)
      allow(http_double).to receive(:use_ssl=)
      allow(http_double).to receive(:read_timeout=)
      allow(http_double).to receive(:open_timeout=)
      allow(Net::HTTP::Get).to receive(:new).and_return(request_double)
      allow(request_double).to receive(:[]=)
      expect(http_double).to receive(:request).with(request_double).and_return(response)

      expect(adapter.get(uri.to_s)).to eq(response)
    end

    it 'mapeia erros de rede para ConnectionError' do
      allow(Net::HTTP).to receive(:new).and_raise(Timeout::Error, 'boom')

      expect { adapter.get(uri.to_s) }.to raise_error(CongregaPlenum::ConnectionError)
    end
  end
end
# rubocop:enable Metrics/BlockLength
