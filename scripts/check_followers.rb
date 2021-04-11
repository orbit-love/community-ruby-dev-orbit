#!/usr/bin/env ruby
# frozen_string_literal: true

require "dev_orbit"
require "thor"

module DevOrbit
  module Scripts
    class CheckFollowers < Thor
      desc "render", "check for new DEV followers and push them to Orbit"
      def render
        client = DevOrbit::Client.new
        client.followers
      end
    end
  end
end
