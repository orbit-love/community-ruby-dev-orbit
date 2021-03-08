# frozen_string_literal: true

require 'net/http'
require 'json'

class DevOrbit::Orbit
  def self.call(type:, data:, workspace_id:, api_key:)
    if type == 'comments'
      data[:comments].each do |comment|
        DevOrbit::Interactions::Comment.new(
          article_title: data.transform_keys(&:to_sym)[:title], 
          comment: comment.transform_keys(&:to_sym), 
          url: url,
          workspace_id: workspace_id,
          api_key: api_key
        )
      end
    end
  end
end