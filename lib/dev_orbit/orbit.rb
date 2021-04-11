# frozen_string_literal: true

require "net/http"
require "json"

module DevOrbit
  class Orbit
    def self.call(type:, data:, workspace_id:, api_key:)
      if type == "comments"
        data[:comments].each do |comment|
          DevOrbit::Interactions::Comment.new(
            article_title: data.transform_keys(&:to_sym)[:title],
            comment: comment.transform_keys(&:to_sym),
            url: data[:url],
            workspace_id: workspace_id,
            api_key: api_key
          )
        end
      end

      if type == "followers"
        DevOrbit::Interactions::Follower.new(
          id: data[:follower]["id"],
          name: data[:follower]["name"],
          username: data[:follower]["username"],
          url: data[:follower]["path"],
          workspace_id: workspace_id,
          api_key: api_key
        )
      end
    end
  end
end
