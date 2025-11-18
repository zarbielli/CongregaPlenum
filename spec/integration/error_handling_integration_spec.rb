# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Error handling integration' do
  before do
    CongregaPlenum.configuration = CongregaPlenum::Configuration.new
  end

  it 'levanta CongregaPlenum::RateLimitError em 429' do
    stub_request(:get, %r{/deputados})
      .to_return(status: 429, body: { erros: [] }.to_json)

    client = CongregaPlenum::Client.instance

    expect { client.get('deputados') }.to raise_error(CongregaPlenum::RateLimitError)
  end
end
