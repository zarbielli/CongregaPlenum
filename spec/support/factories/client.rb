# frozen_string_literal: true

module CongregaPlenum
  module Factories
    module_function

    def client(configuration: nil, http_adapter: nil, retry_policy: nil, response_handler: nil)
      configuration ||= CongregaPlenum::Factories.configuration
      response_handler ||= CongregaPlenum::Factories.response_handler

      reset_client_singleton
      CongregaPlenum.configuration = configuration

      CongregaPlenum::Client.instance.tap do |instance|
        attach_client_dependencies(instance, configuration, http_adapter, retry_policy, response_handler)
      end
    end

    def attach_client_dependencies(instance, configuration, http_adapter, retry_policy, response_handler)
      adapter = http_adapter || CongregaPlenum::Factories.http_adapter(configuration: configuration)
      policy = retry_policy || CongregaPlenum::Factories.retry_policy(configuration: configuration)

      instance.instance_variable_set(:@http_adapter, adapter)
      instance.instance_variable_set(:@retry_policy, policy)
      instance.instance_variable_set(:@response_handler, response_handler)
    end
  end
end
