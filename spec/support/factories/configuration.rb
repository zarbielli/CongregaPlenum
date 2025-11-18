# frozen_string_literal: true

module CongregaPlenum
  module Factories
    module_function

    def configuration(overrides = {})
      CongregaPlenum::Configuration.new.tap do |config|
        config.logger = overrides.delete(:logger) || test_logger
        overrides.each do |attribute, value|
          config.public_send("#{attribute}=", value)
        end
      end
    end
  end
end
