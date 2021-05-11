# frozen_string_literal: true

require "net/http"
require "json"
require "action_view"
require_relative "../utils"

module DevOrbit
  module Interactions
    class Follower
      def initialize(id:, name:, username:, url:, workspace_id:, api_key:)
        @id = id
        @name = name
        @username = username
        @url = url
        @workspace_id = workspace_id
        @api_key = api_key

        after_initialize!
      end

      def after_initialize!
        url = URI("https://app.orbit.love/api/v1/#{@workspace_id}/members")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(url)
        req["Accept"] = "application/json"
        req["Content-Type"] = "application/json"
        req["Authorization"] = "Bearer #{@api_key}"
        req["User-Agent"] = "community-ruby-dev-orbit/#{DevOrbit::VERSION}"

        req.body = construct_body

        req.body = req.body.to_json

        response = http.request(req)

        JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)
      end

      def construct_body
        {
          member: {
            name: @name.include?("_") ? @name.split("_").map(&:capitalize).join(" ") : @name,
            devto: @username,
            url: "https://dev.to#{@url}"
          }
        }
      end
    end
  end
end
