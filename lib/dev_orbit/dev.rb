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
      @historical_import = params.fetch(:historical_import, false)
    end

    def process_comments(type:)
      articles = get_articles(type: type)

      return if articles.empty? || articles.nil?

      articles.each do |article|
        comments = get_article_comments(article["id"])

        next if comments.nil? || comments.empty?

        return DevOrbit::Orbit.new(
          type: "comments",
          data: {
            comments: comments,
            title: article["title"],
            url: article["url"]
          },
          workspace_id: @workspace_id,
          api_key: @orbit_api_key,
          historical_import: @historical_import
        ).call
      end
    end

    def process_followers
      followers = get_followers

      return if followers.empty? || followers.nil?

      DevOrbit::Orbit.new(
        type: "followers",
        data: {
          followers: followers
        },
        workspace_id: @workspace_id,
        api_key: @orbit_api_key,
        historical_import: @historical_import,
        last_orbit_member_timestamp: last_orbit_member_timestamp
      ).call
    end

    private

    def get_articles(type:)
      page = 1
      articles = []
      looped_at_least_once = false

      while page >= 1
        page += 1 if looped_at_least_once
        url = URI("https://dev.to/api/articles?username=#{@username}&page=#{page}&per_page=1000") if type == "user"

        if type == "organization"
          url = URI("https://dev.to/api/organizations/#{@organization}/articles?page=#{page}&per_page=1000")
        end

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)

        response = https.request(request)

        break if response.code == "404"

        response = JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)

        articles << response unless response.empty? || response.nil?
        looped_at_least_once = true

        break if response.empty? || response.nil?
      end

      articles.flatten!
    end

    def get_followers
      page = 1
      followers = []
      looped_at_least_once = false

      while page >= 1
        page += 1 if looped_at_least_once
        url = URI("https://dev.to/api/followers/users?page=#{page}&per_page=1000")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["api_key"] = @api_key

        response = https.request(request)

        break if response.code == "404"

        response = JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)

        followers << response unless response.empty? || response.nil?
        looped_at_least_once = true

        break if response.empty? || response.nil?
      end

      followers.flatten!
    end

    def get_article_comments(id)
      url = URI("https://dev.to/api/comments?a_id=#{id}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = https.request(request)

      comments = JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)

      return if comments.nil? || comments.empty?

      comments
    end

    def last_orbit_member_timestamp
      @last_orbit_member_timestamp ||= begin
        url = URI("https://app.orbit.love/api/v1/#{@workspace_id}/members?direction=DESC&items=10&identity=devto&sort=created_at")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Accept"] = "application/json"
        request["Authorization"] = "Bearer #{@orbit_api_key}"
        request["User-Agent"] = "community-ruby-dev-orbit/#{DevOrbit::VERSION}"

        response = http.request(request)
        response = JSON.parse(response.body)

        return nil if response["data"].nil? || response["data"].empty?

        response["data"][0]["attributes"]["created_at"]
      end
    end
  end
end
