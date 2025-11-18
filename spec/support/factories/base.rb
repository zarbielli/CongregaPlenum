# frozen_string_literal: true

require 'stringio'

module CongregaPlenum
  module Factories
    module_function

    def test_logger
      Logger.new(StringIO.new)
    end

    def reset_client_singleton
      return unless CongregaPlenum::Client.instance_variable_defined?(:@singleton__instance__)

      CongregaPlenum::Client.remove_instance_variable(:@singleton__instance__)
    end
  end
end
