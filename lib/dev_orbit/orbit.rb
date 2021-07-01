# frozen_string_literal: true

require "net/http"
require "json"
require "active_support/time"

module DevOrbit
  class Orbit
    def initialize(type:, data:, workspace_id:, api_key:, historical_import: false)
      @type = type
      @data = data
      @workspace_id = workspace_id
      @api_key = api_key
      @historical_import = historical_import
      @last_orbit_activity_timestamp = last_orbit_activity_timestamp(type)
    end
    
    def call
      if @type == "comments"
        times = 0
        
        @data[:comments].each do |comment|
          unless @historical_import && @last_orbit_activity_timestamp
            next if comment["created_at"] || comment[:created_at] < @last_orbit_activity_timestamp unless @last_orbit_activity_timestamp.nil? 
          end

          if @last_orbit_activity_timestamp && @historical_import == false
            next if comment["created_at"] || comment[:created_at] < @last_orbit_activity_timestamp
          end

          times += 1

          DevOrbit::Interactions::Comment.new(
            article_title: @data.transform_keys(&:to_sym)[:title],
            comment: comment.transform_keys(&:to_sym),
            url: @data[:url],
            workspace_id: @workspace_id,
            api_key: @api_key
          )
        end

        output = "Sent #{times} new DEV comments to your Orbit workspace"
        
        puts output
        return output
      end

      if @type == "followers"
        DevOrbit::Interactions::Follower.new(
          id: @data[:follower]["id"],
          name: @data[:follower]["name"],
          username: @data[:follower]["username"],
          url: @data[:follower]["path"],
          workspace_id: @workspace_id,
          api_key: @api_key
        )
      end
    end

    def last_orbit_activity_timestamp(type)
      @last_orbit_activity_timestamp ||= begin
        if type == "comments"
          activity_type = "custom:dev:comment"
        end

        if type == "followers"
          return nil
        end

        OrbitActivities::Request.new(
          api_key: @api_key,
          workspace_id: @workspace_id,
          user_agent: "community-ruby-dev-orbit/#{DevOrbit::VERSION}",
          action: "latest_activity_timestamp",
          filters: { activity_type: activity_type }
        ).response
      end
    end
  end
end
