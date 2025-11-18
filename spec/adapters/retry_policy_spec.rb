# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe CongregaPlenum::RetryPolicy do
  subject(:policy) { described_class.new(configuration: configuration) }

  let(:logger) { Logger.new(StringIO.new) }
  let(:configuration) do
    CongregaPlenum::Factories.configuration(logger: logger, retries: 2, retry_delay: 0.1)
  end

  describe '#with_retries' do
    it 'tenta novamente quando há erro recuperável' do
      attempts = 0

      expect(policy).to receive(:sleep).at_least(:once)

      result = policy.with_retries('url') do
        attempts += 1
        raise CongregaPlenum::ConnectionError, 'fail' if attempts < 2

        :ok
      end

      expect(result).to eq(:ok)
    end

    it 'propaga erro quando estoura o limite' do
      expect do
        policy.with_retries('url') { raise CongregaPlenum::ConnectionError, 'boom' }
      end.to raise_error(CongregaPlenum::ConnectionError)
    end
  end
end
