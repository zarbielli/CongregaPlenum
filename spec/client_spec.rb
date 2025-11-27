# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

# rubocop:disable Metrics/BlockLength
RSpec.describe CongregaPlenum::Client do
  describe '#get' do
    let(:logger) { Logger.new(StringIO.new) }
    let(:configuration) { CongregaPlenum::Factories.configuration(logger: logger) }
    let(:http_adapter) { instance_double(CongregaPlenum::HttpAdapter) }
    let(:retry_policy) { instance_double(CongregaPlenum::RetryPolicy) }
    let(:response_handler) { instance_double(CongregaPlenum::ResponseHandler) }
    let(:http_response) { instance_double(Net::HTTPResponse) }
    let(:client) do
      CongregaPlenum::Factories.client(
        configuration: configuration,
        http_adapter: http_adapter,
        retry_policy: retry_policy,
        response_handler: response_handler
      )
    end

    it 'monta a URL com formato json por padrão e usa os adapters configurados' do
      expected_url = "#{configuration.base_url}/deputados?ativo=true&formato=json"
      parsed_response = { 'dados' => [] }

      expect(retry_policy).to receive(:with_retries).with(expected_url).and_yield
      expect(http_adapter).to receive(:get).with(expected_url).and_return(http_response)
      expect(response_handler).to receive(:handle).with(http_response,
                                                        expected_url).and_return(parsed_response)

      expect(client.get('deputados', ativo: true)).to eq(parsed_response)
    end

    it 'mantém parâmetros já informados como formato e normaliza o endpoint' do
      parsed_response = { 'dados' => [{ 'id' => 1 }] }
      expected_url = "#{configuration.base_url}/legislaturas?pagina=2&formato=xml"

      expect(retry_policy).to receive(:with_retries).with(expected_url).and_yield
      allow(http_adapter).to receive(:get).and_return(http_response)
      allow(response_handler).to receive(:handle).and_return(parsed_response)

      expect(client.get('/legislaturas', pagina: 2, formato: 'xml')).to eq(parsed_response)
    end
  end

  describe '#get_paginated' do
    let(:logger) { Logger.new(StringIO.new) }
    let(:configuration) do
      CongregaPlenum::Factories.configuration(logger: logger, rate_limit_delay: rate_limit_delay)
    end
    let(:client) { CongregaPlenum::Factories.client(configuration: configuration) }

    context 'quando existem várias páginas' do
      let(:rate_limit_delay) { 0.2 }

      it 'concatena os resultados e aplica o delay configurado' do
        first_page = CongregaPlenum::Factories.paginated_response(
          dados: [{ 'id' => 1 }],
          next_link: 'next'
        )
        second_page = CongregaPlenum::Factories.api_response(dados: [{ 'id' => 2 }])

        expect(client).to receive(:get)
          .with('deputados', hash_including(pagina: 1, formato: 'json', itens: 20))
          .and_return(first_page)
        expect(client).to receive(:get)
          .with('deputados', hash_including(pagina: 2, formato: 'json', itens: 20))
          .and_return(second_page)
        expect(client).to receive(:sleep).with(rate_limit_delay)

        result = client.get_paginated('deputados', itens: 20)
        expect(result).to eq([{ 'id' => 1 }, { 'id' => 2 }])
      end
    end

    context 'quando a primeira página não traz dados' do
      let(:rate_limit_delay) { 0 }

      it 'retorna array vazio imediatamente' do
        empty_page = CongregaPlenum::Factories.api_response(dados: [])

        expect(client).to receive(:get)
          .with('partidos', hash_including(pagina: 1, formato: 'json'))
          .and_return(empty_page)

        expect(client.get_paginated('partidos')).to eq([])
      end
    end

    context 'quando o delay configurado é zero' do
      let(:rate_limit_delay) { 0 }

      it 'não invoca sleep entre páginas' do
        responses = [
          CongregaPlenum::Factories.paginated_response(
            dados: [{ 'id' => 1 }],
            next_link: 'next'
          ),
          CongregaPlenum::Factories.api_response(dados: [{ 'id' => 2 }])
        ]
        allow(client).to receive(:get).and_return(*responses)

        expect(client).not_to receive(:sleep)

        expect(client.get_paginated('deputados', itens: 50)).to eq([{ 'id' => 1 }, { 'id' => 2 }])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
