# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CongregaPlenum::CongressmenService do
  before do
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new
  end

  describe '.fetch_all_by_legislature' do
    it 'agrega lista paginada e detalhes' do
      stub_request(:get, %r{/deputados\?}).to_return(
        status: 200,
        body: {
          dados: [{ 'id' => 1 }, { 'id' => 2 }],
          links: []
        }.to_json
      )
      stub_request(:get, %r{/deputados/1}).to_return(status: 200, body: { dados: { id: 1 } }.to_json)
      stub_request(:get, %r{/deputados/2}).to_return(status: 200, body: { dados: { id: 2 } }.to_json)

      result = described_class.fetch_all_by_legislature(57)

      expect(result).to eq([{ 'id' => 1 }, { 'id' => 2 }])
    end
  end
end
# rubocop:enable Metrics/BlockLength
