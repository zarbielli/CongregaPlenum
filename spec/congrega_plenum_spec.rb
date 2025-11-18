# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CongregaPlenum do
  around do |example|
    original_configuration = CongregaPlenum.configuration
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new

    example.run
  ensure
    CongregaPlenum.configuration = original_configuration
  end

  it 'expõe o número de versão' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.configure' do
    it 'disponibiliza a configuração atual no bloco' do
      current_configuration = described_class.configuration

      expect { |probe| described_class.configure(&probe) }.to yield_with_args(current_configuration)
    end

    it 'permite alterar atributos sem recriar a instância' do
      existing_configuration = described_class.configuration

      described_class.configure do |config|
        config.base_url = 'https://example.org/api'
        config.timeout = 5
      end

      expect(described_class.configuration).to equal(existing_configuration)
      expect(existing_configuration.base_url).to eq('https://example.org/api')
      expect(existing_configuration.timeout).to eq(5)
    end

    it 'instancia configuração padrão quando nenhuma existir' do
      described_class.configuration = nil

      described_class.configure do |config|
        expect(config).to be_a(CongregaPlenum::Configuration)
        config.retries = 7
      end

      expect(described_class.configuration.retries).to eq(7)
    end
  end
end

RSpec.describe CongregaPlenum::Configuration do
  subject(:configuration) { described_class.new }

  it 'define valores padrão consistentes' do
    expect(configuration.base_url).to eq('https://dadosabertos.camara.leg.br/api/v2')
    expect(configuration.timeout).to eq(30)
    expect(configuration.retries).to eq(3)
    expect(configuration.retry_delay).to eq(1.0)
    expect(configuration.rate_limit_delay).to eq(0.1)
    expect(configuration.logger).to be_a(Logger)
  end
end
# rubocop:enable Metrics/BlockLength
