# frozen_string_literal: true

module CongregaPlenum
  module Factories
    module_function

    def http_adapter(configuration: nil)
      CongregaPlenum::HttpAdapter.new(configuration: configuration || CongregaPlenum::Factories.configuration)
    end

    def retry_policy(configuration: nil)
      CongregaPlenum::RetryPolicy.new(configuration: configuration || CongregaPlenum::Factories.configuration)
    end

    def response_handler
      CongregaPlenum::ResponseHandler.new
    end
  end
end
