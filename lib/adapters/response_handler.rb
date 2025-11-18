# frozen_string_literal: true

module CongregaPlenum
  # Centralizes HTTP status validation and JSON parsing.
  class ResponseHandler
    # Validates an HTTP response code and returns the parsed JSON body.
    #
    # @param response [Net::HTTPResponse]
    # @param url [String]
    # @return [Hash]
    def handle(response, url)
      case response.code.to_i
      when 200 then parse_json_response(response, url)
      when 429 then raise RateLimitError, "Rate limit exceeded for #{url}"
      when 404 then raise APIError, "Resource not found: #{url}"
      when 500..599
        raise APIError, "Server error (#{response.code}) for #{url}: #{response.message}"
      else
        raise APIError, "HTTP Error #{response.code} for #{url}: #{response.message}"
      end
    end

    private

    # Parses a JSON response body, raising {APIError} when invalid.
    def parse_json_response(response, url)
      JSON.parse(response.body)
    rescue JSON::ParserError => e
      raise APIError, "Invalid JSON response from #{url}: #{e.message}"
    end
  end
end
