# frozen_string_literal: true

require "spec_helper"

RSpec.describe DevOrbit::Interactions::Comment do
  let(:subject) do
    DevOrbit::Interactions::Comment.new(
      article_title: "Sample Article",
      url: "https://example.com/article",
      comment: {
        created_at: "2021-03-09",
        id_code: '1234',
        body_html: "<p>This is a great post! Now I need to learn everything here! 😂</p>", 
        user: {
          name: "Worf",
          username: "worf"
        }
      }, 
      workspace_id: "1234",
      api_key: "12345"
    )
  end

  describe "#construct_body" do
    it "returns a fully constructed request body hash" do
      stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
        .with(
          headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json' },
          body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-1234\",\"title\":\"Commented on the DEV blog post: Sample Article\",\"description\":\"This is a great post! Now I need to learn everything here! 😂\",\"occurred_at\":\"2021-03-09\",\"link\":\"https://example.com/article\",\"member\":{\"name\":\"Worf\",\"devto\":\"worf\"}},\"identity\":{\"source\":\"devto\",\"username\":\"worf\"}}"
        )
        .to_return(
          status: 200,
          body: {
            response: {
              code: 'SUCCESS'
            }
          }.to_json.to_s
        )

      content = subject.construct_body
      
      expect(content[:activity][:description]).to eql("This is a great post! Now I need to learn everything here! 😂")
    end
  end
end