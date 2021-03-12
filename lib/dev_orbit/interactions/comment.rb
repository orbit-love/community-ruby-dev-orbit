# frozen_string_literal: true

require "net/http"
require "json"
require "action_view"
require_relative "../utils"

module DevOrbit
  module Interactions
    class Comment
      def initialize(article_title:, url:, comment:, workspace_id:, api_key:)
        @article_title = article_title
        @url = url
        @id = comment[:id_code]
        @created_at = comment[:created_at]
        @body = sanitize_comment(comment[:body_html])
        @commenter = construct_commenter(comment[:user].transform_keys(&:to_sym))
        @workspace_id = workspace_id
        @api_key = api_key

        after_initialize!
      end

      def after_initialize!
        url = URI("https://app.orbit.love/api/v1/#{@workspace_id}/activities")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(url)
        req["Accept"] = "application/json"
        req["Content-Type"] = "application/json"
        req["Authorization"] = "Bearer #{@api_key}"

        req.body = construct_body

        req.body = req.body.to_json

        response = http.request(req)

        JSON.parse(response.body) if DevOrbit::Utils.valid_json?(response.body)
      end

      def construct_body
        hash = {
          activity: {
            activity_type: "dev:comment",
            key: "dev-comment-#{@id}",
            title: "Commented on the DEV blog post: #{@article_title}",
            description: @body,
            occurred_at: @created_at,
            link: @url,
            member: {
              name: @commenter[:name],
              devto: @commenter[:username]
            }
          },
          identity: {
            source: "devto",
            username: @commenter[:username]
          }
        }

        hash[:activity][:member].merge!(twitter: @commenter[:twitter]) if @commenter[:twitter]

        hash[:activity][:member].merge!(github: @commenter[:github]) if @commenter[:github]

        hash
      end

      private

      def construct_commenter(commenter)
        hash = {
          'name': commenter[:name],
          'username': commenter[:username]
        }

        unless commenter[:twitter_username].nil? || commenter[:twitter_username] == ""
          hash.merge!('twitter': commenter[:twitter_username])
        end

        unless commenter[:github_username].nil? || commenter[:github_username] == ""
          hash.merge!('github': commenter[:github_username])
        end

        hash
      end

      def sanitize_comment(comment)
        comment = ActionView::Base.full_sanitizer.sanitize(comment)

        comment.gsub("\n", " ")
      end
    end
  end
end
