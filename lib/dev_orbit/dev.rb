# frozen_string_literal: true

require "net/http"
require "json"
require "active_support/time"
require_relative "utils"

module DevOrbit
  class Dev
    def initialize(params = {})
      @username = params.fetch(:username, ENV["DEV_USERNAME"])
      @organization = params.fetch(:organization, ENV["DEV_ORGANIZATION"])
      @api_key = params.fetch(:api_key, ENV["DEV_API_KEY"])
      @workspace_id = params.fetch(:workspace_id, ENV["ORBIT_WORKSPACE_ID"])
      @orbit_api_key = params.fetch(:orbit_api_key, ENV["ORBIT_API_KEY"])
    end

    def process_comments(type:)
      articles = get_articles(type: type)

      articles.each do |article|
        require 'byebug'
        #byebug
        comments = get_article_comments(article["id"])

        next if comments.nil? || comments.empty?

        DevOrbit::Orbit.call(
          type: "comments",
          data: {
            comments: comments,
            title: article["title"],
            url: article["url"]
          },
          workspace_id: @workspace_id,
          api_key: @orbit_api_key
        )
      end
    end

    def process_followers
      followers = get_followers

      followers.each do |follower|
        next if follower.nil? || follower.empty?

        DevOrbit::Orbit.call(
          type: "followers",
          data: {
            follower: follower
          },
          workspace_id: @workspace_id,
          api_key: @orbit_api_key
        )
      end
    end

    private

    def get_articles(type:)
      if type == "user"
        url = URI("https://dev.to/api/articles?username=#{@username}&top=1")
      end

      if type == "organization"
        url = URI("https://dev.to/api/organizations/#{@organization}/articles")
      end

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)

      JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)
    end

    def get_followers
      url = URI("https://dev.to/api/followers/users")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["api_key"] = @api_key

      response = https.request(request)

      JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)
    end

    def get_article_comments(id)
      url = URI("https://dev.to/api/comments?a_id=#{id}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)

      comments = JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)

      return if comments.nil? || comments.empty?

      filter_comments(comments)
    end

    def filter_comments(comments)
      comments.select do |comment|
        comment["created_at"] <= 1.day.ago
      end
    end
  end
end
