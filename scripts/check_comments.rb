#!/usr/bin/env ruby
# frozen_string_literal: true

require "dev_orbit"

client = DevOrbit::Client.new

response = client.comments

puts response
