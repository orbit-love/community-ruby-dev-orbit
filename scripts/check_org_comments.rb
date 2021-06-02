#!/usr/bin/env ruby
# frozen_string_literal: true

require "dev_orbit"
require "thor"

module DevOrbit
  module Scripts
    class CheckOrgComments < Thor
      desc "render", "check for new DEV comments on an organization and push them to Orbit"
      def render
        client = DevOrbit::Client.new
        client.organization_comments
      end
    end
  end
end
