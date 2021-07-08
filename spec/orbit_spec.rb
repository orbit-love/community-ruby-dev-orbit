# frozen_string_literal: true

require "spec_helper"

RSpec.describe DevOrbit::Orbit do
  describe "#call" do
    context "with historical import set to false and a type of followers with new followers" do
      it "sends the new followers to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("followers").and_return(nil)
        stub_request(:post, "https://app.orbit.love/api/v1/1234/members")
          .with(
            body: "{\"member\":{\"name\":\"Ploni Almoni\",\"devto\":\"ploni\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        client = DevOrbit::Orbit.new(
          type: "followers",
          data: followers_stub_with_one_new_member,
          workspace_id: "1234",
          api_key: "123",
          historical_import: false,
          last_orbit_member_timestamp: "2021-06-23"
        )

        expect(client.call).to eq("Sent 1 new followers to Orbit")
      end
    end

    context "with historical import set to false and a type of followers with no new followers" do
      it "does not send new followers to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("followers").and_return(nil)

        client = DevOrbit::Orbit.new(
          type: "followers",
          data: followers_stub_with_no_new_members,
          workspace_id: "1234",
          api_key: "123",
          historical_import: false,
          last_orbit_member_timestamp: "2021-06-23"
        )

        expect(client.call).to eq("Sent 0 new followers to Orbit")
      end
    end

    context "with historical import set to true and a type of followers" do
      it "sends all followers to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("followers").and_return(nil)
        stub_request(:post, "https://app.orbit.love/api/v1/1234/members")
          .with(
            body: "{\"member\":{\"name\":\"Ploni Almoni\",\"devto\":\"ploni\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        stub_request(:post, "https://app.orbit.love/api/v1/1234/members")
          .with(
            body: "{\"member\":{\"name\":\"Plonit Almonit\",\"devto\":\"plonit\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        client = DevOrbit::Orbit.new(
          type: "followers",
          data: followers_stub_with_one_new_member,
          workspace_id: "1234",
          api_key: "123",
          historical_import: true,
          last_orbit_member_timestamp: "2021-06-23"
        )

        expect(client.call).to eq("Sent 2 new followers to Orbit")
      end
    end

    context "with historical import set to false and a type of comments with new comments to add" do
      it "sends new comments to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("comments").and_return("2021-06-24")

        stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
          .with(
            body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-\",\"title\":\"Commented on the DEV blog post: A title\",\"description\":\"A comment\",\"occurred_at\":\"2021-07-01\",\"link\":null,\"member\":{\"name\":\"Ploni Almoni\",\"devto\":\"ploni\"}},\"identity\":{\"source\":\"devto\",\"username\":\"ploni\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        client = DevOrbit::Orbit.new(
          type: "comments",
          data: comments_stub_with_one_new_comment,
          workspace_id: "1234",
          api_key: "123",
          historical_import: false,
          last_orbit_member_timestamp: nil
        )

        expect(client.call).to eq("Sent 1 new DEV comments to your Orbit workspace")
      end
    end

    context "with historical import set to false and a type of comments with no new comments to add" do
      it "does not send any comments to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("comments").and_return("2021-06-24")

        client = DevOrbit::Orbit.new(
          type: "comments",
          data: comments_stub_with_no_new_comments,
          workspace_id: "1234",
          api_key: "123",
          historical_import: false,
          last_orbit_member_timestamp: nil
        )

        expect(client.call).to eq("Sent 0 new DEV comments to your Orbit workspace")
      end
    end

    context "with historical import set to true" do
      it "it sends all comments to Orbit" do
        allow_any_instance_of(DevOrbit::Orbit).to receive(:last_orbit_activity_timestamp).with("comments").and_return("2021-06-24")

        stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
          .with(
            body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-\",\"title\":\"Commented on the DEV blog post: A title\",\"description\":\"A comment\",\"occurred_at\":\"2021-07-01\",\"link\":null,\"member\":{\"name\":\"Ploni Almoni\",\"devto\":\"ploni\"}},\"identity\":{\"source\":\"devto\",\"username\":\"ploni\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        stub_request(:post, "https://app.orbit.love/api/v1/1234/activities")
          .with(
            body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-\",\"title\":\"Commented on the DEV blog post: A title\",\"description\":\"A comment\",\"occurred_at\":\"2021-05-11\",\"link\":null,\"member\":{\"name\":\"Plonit Almonit\",\"devto\":\"plonit\"}},\"identity\":{\"source\":\"devto\",\"username\":\"plonit\"}}",
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 123",
              "Content-Type" => "application/json",
              "User-Agent" => "community-ruby-dev-orbit/#{DevOrbit::VERSION}"
            }
          ).to_return(
            status: 200,
            body: {
              response: {
                code: "SUCCESS"
              }
            }.to_json.to_s
          )

        client = DevOrbit::Orbit.new(
          type: "comments",
          data: comments_stub_with_one_new_comment,
          workspace_id: "1234",
          api_key: "123",
          historical_import: true,
          last_orbit_member_timestamp: nil
        )

        expect(client.call).to eq("Sent 2 new DEV comments to your Orbit workspace")
      end
    end
  end

  def followers_stub_with_one_new_member
    {
      followers: [
        {
          "created_at" => "2021-06-25",
          "id" => "abc123",
          "name" => "Ploni Almoni",
          "username" => "ploni",
          "path" => "dev.to/ploni"
        },
        {
          "created_at" => "2021-06-20",
          "id" => "zef123",
          "name" => "Plonit Almonit",
          "username" => "plonit",
          "path" => "dev.to/plonit"
        }
      ]
    }
  end

  def followers_stub_with_no_new_members
    {
      followers: [
        {
          "created_at" => "2021-06-20",
          "id" => "zef123",
          "name" => "Plonit Almonit",
          "username" => "plonit",
          "path" => "dev.to/plonit"
        }
      ]
    }
  end

  def comments_stub_with_one_new_comment
    {
      title: "A title",
      comments: [
        {
          "created_at" => "2021-07-01",
          "url" => "https://www.example.com",
          "body_html" => "<p>A comment</p>",
          "user" => {
            "username" => "ploni",
            "name" => "Ploni Almoni"
          }
        },
        {
          "created_at" => "2021-05-11",
          "url" => "https://www.example.com",
          "body_html" => "<p>A comment</p>",
          "user" => {
            "username" => "plonit",
            "name" => "Plonit Almonit"
          }
        }
      ]
    }
  end

  def comments_stub_with_no_new_comments
    {
      title: "A title",
      comments: [
        "created_at" => "2021-05-11",
        "url" => "https://www.example.com",
        "body_html" => "<p>A comment</p>",
        "user" => {
          "username" => "ploni",
          "name" => "Ploni Almoni"
        }
      ]
    }
  end
end
