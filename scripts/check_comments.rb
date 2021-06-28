#!/usr/bin/env ruby
# frozen_string_literal: true

require "dev_orbit"
require "thor"

module DevOrbit
  module Scripts
    class CheckComments < Thor
      desc "render", "check for new DEV comments and push them to Orbit"
      def render(*params)
        client = DevOrbit::Client.new(historical_import: params[0])
        client.comments
      end
    end
  end
end
