# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rate limit delay integration' do
  before do
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new.tap do |config|
      config.rate_limit_delay = 0
    end
  end

  it 'avança pelas páginas sem aguardar quando delay é zero' do
    stub_request(:get, %r{/partidos\?})
      .with(query: hash_including(pagina: '1'))
      .to_return(
        status: 200,
        body: {
          dados: [{ id: 1 }],
          links: [{ rel: 'next', href: 'prox' }]
        }.to_json
      )
    stub_request(:get, %r{/partidos\?})
      .with(query: hash_including(pagina: '2'))
      .to_return(status: 200, body: { dados: [{ id: 2 }], links: [] }.to_json)

    client = CongregaPlenum::Client.instance

    result = client.get_paginated('partidos', itens: 20)

    expect(result.size).to eq(2)
  end
end
