# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CongregaPlenum::LegislaturesService do
  before do
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new
  end

  describe '.fetch_all' do
    it 'retorna legislaturas em lote' do
      stub_request(:get, %r{/legislaturas\?}).to_return(
        status: 200,
        body: {
          dados: [{ 'id' => 55 }],
          links: []
        }.to_json
      )

      expect(described_class.fetch_all).to eq([{ 'id' => 55 }])
    end
  end

  describe '.fetch_mesa' do
    it 'exibe composição da mesa' do
      stub_request(:get, %r{/legislaturas/55/mesa}).to_return(
        status: 200,
        body: { dados: [{ 'id' => 1 }] }.to_json
      )

      expect(described_class.fetch_mesa(55)).to eq([{ 'id' => 1 }])
    end
  end
end
