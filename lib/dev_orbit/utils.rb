# frozen_string_literal: true

module DevOrbit
  class Utils
    def self.valid_json?(string)
      !JSON.parse(string).nil?
    rescue JSON::ParserError
      false
    end
  end
end
