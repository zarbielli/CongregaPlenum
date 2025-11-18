# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'CongregaPlenum client integration' do
  let(:configuration) { CongregaPlenum::Configuration.new }

  before do
    CongregaPlenum.configuration = configuration
  end

  it 'realiza GET único e processa resposta JSON' do
    stub_request(:get, %r{/deputados}).to_return(
      status: 200,
      body: { dados: [{ id: 1 }] }.to_json
    )

    client = CongregaPlenum::Client.instance

    response = client.get('deputados')

    expect(response['dados']).to eq([{ 'id' => 1 }])
  end
end
