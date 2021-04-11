# frozen_string_literal: true

require "spec_helper"

RSpec.describe DevOrbit::Interactions::Follower do
  let(:subject) do
    DevOrbit::Interactions::Follower.new(
      id: "112",
      url: "/bengreenberg",
      name: "Ben Greenberg",
      username: "bengreenberg",
      workspace_id: "1234",
      api_key: "12345"
    )
  end

  describe "#construct_body" do
    it "returns a fully constructed request body hash" do
      stub_request(:post, "https://app.orbit.love/api/v1/1234/members")
        .with(
          headers: { 'Authorization' => "Bearer 12345", 'Content-Type' => 'application/json' },
          body: "{\"member\":{\"name\":\"Ben Greenberg\",\"devto\":\"bengreenberg\",\"url\":\"https://dev.to/bengreenberg\"}}"
        ).to_return(
          status: 200,
          body: {
            response: {
              code: 'SUCCESS'
            }
          }.to_json.to_s
        )

      content = subject.construct_body
      
      expect(content[:member][:name]).to eql("Ben Greenberg")
    end
  end
end