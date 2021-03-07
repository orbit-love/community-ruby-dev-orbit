# frozen_string_literal: true

require 'net/http'
require 'json'
require 'active_support/time'

class DevOrbit::Dev
  def initialize(params = {})
    @username = params.fetch(:username, ENV['DEV_USERNAME'])
    @api_key = params.fetch(:api_key, ENV['DEV_API_KEY'])
  end

  def process_comments
    articles = get_articles

    articles.each do |article|
      comments = get_article_comments(article['id'])
      DevOrbit::Orbit.call(type: 'comments', data: { comments: comments, title: article['title'] }) unless comments.empty?
    end
  end

  def get_articles
    url = URI("https://dev.to/api/articles?username=#{@username}&top=1")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)

    response = https.request(request)

    JSON.parse(response.body)
  end


  def get_article_comments(id)
    url = URI("https://dev.to/api/comments?a_id=#{id}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    comments = JSON.parse(response.body)

    filter_comments(comments)
  end

  def filter_comments(comments)
    comments.select { |comment|
      comment['created_at'] >= 1.day.ago
    }
  end
end