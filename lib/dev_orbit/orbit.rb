# frozen_string_literal: true

require 'net/http'
require 'json'

class DevOrbit::Orbit
  def self.call(type:, data:)
    if type == 'comments'
      data[:comments].each do |comment|
        DevOrbit::Interactions::Comment.new(data[:title], comment)
      end
    end
  end
end