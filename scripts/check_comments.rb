#!/usr/bin/env ruby
# frozen_string_literal: true

require "dev_orbit"
require "thor"

module DevOrbit
  module Scripts
    class CheckComments < Thor
      desc "render", "check for new DEV comments and push them to Orbit"
      def render
        client = DevOrbit::Client.new
        response = client.comments
        puts response
      end
    end
  end
end
