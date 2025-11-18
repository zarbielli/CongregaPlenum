# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CongregaPlenum::PartiesService do
  before do
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new
  end

  describe '.fetch_all' do
    it 'retorna lista enriquecida' do
      stub_request(:get, %r{/partidos\?}).to_return(
        status: 200,
        body: {
          dados: [{ 'id' => 10 }],
          links: []
        }.to_json
      )
      stub_request(:get, %r{/partidos/10}).to_return(status: 200, body: { dados: { id: 10 } }.to_json)

      expect(described_class.fetch_all).to eq([{ 'id' => 10 }])
    end
  end
end
