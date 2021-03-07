# frozen_string_literal: true

require 'net/http'
require 'json'

class DevOrbit::Interactions::Comment
  def initialize(article_title, comment)
    @article_title = article_title
    @id = comment['id_code']
    @created_at = comment['created_at']
    @commenter = construct_commenter(comment['user'])

    after_initialize!
  end

  def after_initialize!
    url = URI("https://app.orbit.love/api/v1/#{ENV['ORBIT_WORKSPACE_ID']}/activities")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri)
    req['Accept'] = 'application/json'
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{ENV['ORBIT_API_KEY']}"

    req.body = {
      activity: {
        activity_type: 'dev:comment',
        key: "dev-comment-#{@id}",
        title: "Commented on #{@article_title}",
        description: params[:resource],
        occurred_at: @created_at.iso8601,
      },
      member: {
        name: @commenter['name'],
        devto: @commenter['username'],
      },
    }

    if @commenter['twitter']
      req.body[:member].merge!(twitter: @commenter['twitter'])
    end

    if @commenter['github']
      req.body[:member].merge!(github: @commenter['github'])
    end

    req.body = req.body.to_json

    http.request(req)
  end

  def construct_commenter(commenter)
    hash = {
      'name': commenter['name'],
      'username': commenter['username'],
    }

    hash.merge!('twitter': commenter['twitter_username']) unless commenter['twitter_username'] == nil || commenter['twitter_username'] == ''

    hash.merge!('github': commenter['github_username']) unless commenter['github_username'] == nil || commenter['github_username'] == ''

    hash.merge!('profile_image': commenter['profile_image']) unless commenter['profile_image'] == nil || commenter['profile_image'] == ''

    hash
  end
end