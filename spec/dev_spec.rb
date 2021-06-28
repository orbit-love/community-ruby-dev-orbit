# frozen_string_literal: true

require "spec_helper"

RSpec.describe DevOrbit::Dev do
  let(:subject) do
    DevOrbit::Dev.new(
      api_key: "12345",
      username: "test",
      workspace_id: "test",
      orbit_api_key: "12345",
      historical_import: false
    )
  end

  describe "#process_comments" do
    context "with historical import set to false and no newer items than the latest activity for the type in Orbit" do
      it "posts no new comments to the Orbit workspace from DEV" do
        stub_request(:get, "https://dev.to/api/articles?top=1&username=test").to_return(status: 200)
        stub_request(:get, "https://dev.to/api/comments?a_id=123").to_return(status: 200)
        stub_request(:post, "https://app.orbit.love/api/v1/test/activities").to_return(status: 200)
        stub_request(:get, "https://app.orbit.love/api/v1/test/activities?activity_type=custom:dev:comment&direction=DESC&items=10")
          .with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 12345",
              "User-Agent" => "community-ruby-dev-orbit/0.3.0"
            }
          )
          .to_return(
            status: 200,
            body: {
              data: [
                {
                  id: "6",
                  type: "spec_activity",
                  attributes: {
                    action: "spec_action",
                    created_at: "2021-06-23T16:03:02.052Z",
                    key: "spec_activity_key#1",
                    occurred_at: "2021-04-01T16:03:02.050Z",
                    type: "SpecActivity",
                    tags: "[\"spec-tag-1\"]",
                    orbit_url: "https://localhost:3000/test/activities/6",
                    weight: "1.0"
                  },
                  relationships: {
                    activity_type: {
                      data: {
                        id: "20",
                        type: "activity_type"
                      }
                    }
                  },
                  member: {
                    data: {
                      id: "3",
                      type: "member"
                    }
                  }
                }
              ]
            }.to_json.to_s,
            headers: {}
          )
        allow(subject).to receive(:get_articles).and_return(article_stub)
        allow(subject).to receive(:get_article_comments).and_return(comment_stub)

        expect(subject.process_comments(type: "user")).to eq("Sent 0 new DEV comments to your Orbit workspace")
      end
    end

    context "with historical import set to false and newer items than the latest activity for the type in Orbit" do
      it "posts the newer items to the Orbit workspace from DEV" do
        stub_request(:get, "https://dev.to/api/articles?top=1&username=test").to_return(status: 200)
        stub_request(:get, "https://dev.to/api/comments?a_id=123").to_return(status: 200)
        stub_request(:post, "https://app.orbit.love/api/v1/test/activities")
          .with(
            body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-m357\",\"title\":\"Commented on the DEV blog post: \",\"description\":\"  ...  ...   \",\"occurred_at\":\"2021-03-07T17:19:40.000Z\",\"link\":null,\"member\":{\"name\":\"Dario Waelchi\",\"devto\":\"dariowaelchi\"}},\"identity\":{\"source\":\"devto\",\"username\":\"dariowaelchi\"}}",
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => "Bearer 12345",
              "Content-Type" => "application/json",
              "Host" => "app.orbit.love",
              "User-Agent" => "community-ruby-dev-orbit/0.3.0"
            }
          )
          .to_return(status: 200, body: {
            response: {
              code: "SUCCESS"
            }
          }.to_json.to_s, headers: {})
        stub_request(:get, "https://app.orbit.love/api/v1/test/activities?activity_type=custom:dev:comment&direction=DESC&items=10")
          .with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 12345",
              "User-Agent" => "community-ruby-dev-orbit/0.3.0"
            }
          )
          .to_return(
            status: 200,
            body: {
              data: [
                {
                  id: "6",
                  type: "spec_activity",
                  attributes: {
                    action: "spec_action",
                    created_at: "2021-02-23T16:03:02.052Z",
                    key: "spec_activity_key#1",
                    occurred_at: "2021-02-01T16:03:02.050Z",
                    type: "SpecActivity",
                    tags: "[\"spec-tag-1\"]",
                    orbit_url: "https://localhost:3000/test/activities/6",
                    weight: "1.0"
                  },
                  relationships: {
                    activity_type: {
                      data: {
                        id: "20",
                        type: "activity_type"
                      }
                    }
                  },
                  member: {
                    data: {
                      id: "3",
                      type: "member"
                    }
                  }
                }
              ]
            }.to_json.to_s,
            headers: {}
          )
        allow(subject).to receive(:get_articles).and_return(article_stub)
        allow(subject).to receive(:get_article_comments).and_return(comment_stub)

        expect(subject.process_comments(type: "user")).to eq("Sent 1 new DEV comments to your Orbit workspace")
      end
    end

    context "with historical import set to true" do
      it "posts all comments to the Orbit workspace from DEV" do
        stub_request(:get, "https://dev.to/api/articles?top=1&username=test").to_return(status: 200)
        stub_request(:get, "https://dev.to/api/comments?a_id=123").to_return(status: 200)
        stub_request(:post, "https://app.orbit.love/api/v1/test/activities")
          .with(
            body: "{\"activity\":{\"activity_type\":\"dev:comment\",\"tags\":[\"channel:dev\"],\"key\":\"dev-comment-m357\",\"title\":\"Commented on the DEV blog post: \",\"description\":\"  ...  ...   \",\"occurred_at\":\"2021-03-07T17:19:40.000Z\",\"link\":null,\"member\":{\"name\":\"Dario Waelchi\",\"devto\":\"dariowaelchi\"}},\"identity\":{\"source\":\"devto\",\"username\":\"dariowaelchi\"}}",
            headers: {
              "Accept" => "application/json",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => "Bearer 12345",
              "Content-Type" => "application/json",
              "Host" => "app.orbit.love",
              "User-Agent" => "community-ruby-dev-orbit/0.3.0"
            }
          )
          .to_return(status: 200, body: {
            response: {
              code: "SUCCESS"
            }
          }.to_json.to_s, headers: {})
        stub_request(:get, "https://app.orbit.love/api/v1/test/activities?activity_type=custom:dev:comment&direction=DESC&items=10")
          .with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer 12345",
              "User-Agent" => "community-ruby-dev-orbit/0.3.0"
            }
          )
          .to_return(
            status: 200,
            body: {
              data: [
                {
                  id: "6",
                  type: "spec_activity",
                  attributes: {
                    action: "spec_action",
                    created_at: "2021-06-23T16:03:02.052Z",
                    key: "spec_activity_key#1",
                    occurred_at: "2021-03-07T17:19:40.000Z",
                    type: "SpecActivity",
                    tags: "[\"spec-tag-1\"]",
                    orbit_url: "https://localhost:3000/test/activities/6",
                    weight: "1.0"
                  },
                  relationships: {
                    activity_type: {
                      data: {
                        id: "20",
                        type: "activity_type"
                      }
                    }
                  },
                  member: {
                    data: {
                      id: "3",
                      type: "member"
                    }
                  }
                }
              ]
            }.to_json.to_s,
            headers: {}
          )

        client = DevOrbit::Dev.new(
          api_key: "12345",
          username: "test",
          workspace_id: "test",
          orbit_api_key: "12345",
          historical_import: true
        )
        allow(client).to receive(:get_articles).and_return(article_stub)
        allow(client).to receive(:get_article_comments).and_return(comment_stub)

        expect(client.process_comments(type: "user")).to eq("Sent 1 new DEV comments to your Orbit workspace")
      end
    end
  end

  describe "#process_followers" do
    it "posts followers to the Orbit workspace from DEV" do
      stub_request(:get, "https://dev.to/api/followers/users").to_return(status: 200)
      stub_request(:post, "https://app.orbit.love/api/v1/test/members").to_return(status: 200)
      allow(subject).to receive(:get_followers).and_return(follower_stub)
      allow_any_instance_of(DevOrbit::Orbit).to receive(:call).and_return(follower_response_stub)

      expect(subject.process_followers).to be_truthy
    end
  end

  def follower_stub
    [
      {
        "type_of": "user_follower",
        "id": 12,
        "name": "Mrs. Neda Morissette",
        "path": "/nedamrsmorissette",
        "username": "nedamrsmorissette",
        "profile_image": "https://res.cloudinary.com/https://dev.to/profile.jpg"
      }
    ]
  end

  def article_stub
    [
      {
        "type_of": "article",
        "id": 123,
        "title": "Sample Article",
        "description": "",
        "cover_image": "https://example.com/example.png",
        "readable_publish_date": "Oct 24",
        "social_image": "https://example.com/example.png",
        "tag_list": %w[
          meta
          changelog
        ],
        "tags": "meta, changelog,",
        "slug": "sample-article-245gh",
        "path": "/test/sample-article-245gh",
        "url": "https://dev.to/test/sample-article-245gh",
        "canonical_url": "https://dev.to/test/sample-article-245gh",
        "comments_count": 1,
        "positive_reactions_count": 12,
        "public_reactions_count": 142,
        "collection_id": "",
        "created_at": "2021-03-04T13:41:29Z",
        "edited_at": "2021-03-05T13:56:35Z",
        "crossposted_at": "",
        "published_at": "2021-03-04T13:52:17Z",
        "last_comment_at": "2021-03-08T08:12:43Z",
        "published_timestamp": "2021-03-04T13:52:17Z",
        "user": {
          "name": "Ben Greenberg",
          "username": "bengreenberg",
          "twitter_username": "rabbigreenberg",
          "github_username": "bencgreenberg",
          "website_url": "https://www.bengreenberg.dev",
          "profile_image": "https://example.com/profile.png",
          "profile_image_90": "https://example.com/profile.png"
        },
        "organization": {
          "name": "Test",
          "username": "test",
          "slug": "test",
          "profile_image": "https://example.com/profile.png",
          "profile_image_90": "https://example.com/profile.png"
        }
      }
    ]
  end

  def comment_stub
    [
      {
        "type_of": "comment",
        "id_code": "m357",
        "created_at": "2021-03-07T17:19:40.000Z",
        "body_html": "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body>\n<p>...</p>\n\n<p>...</p>\n\n</body></html>\n",
        "user": {
          "name": "Dario Waelchi",
          "username": "dariowaelchi",
          "twitter_username": "",
          "github_username": "",
          "website_url": "",
          "profile_image": "https://res.cloudinary.com/...png",
          "profile_image_90": "https://res.cloudinary.com/...png"
        },
        "children": [
          {
            "type_of": "comment",
            "id_code": "m35m",
            "created_at": "2021-03-07T17:19:40.000Z",
            "body_html": "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body>\n\n<p>...</p>\n\n</body></html>\n",
            "user": {
              "name": "rhymes",
              "username": "rhymes",
              "twitter_username": "",
              "github_username": "",
              "website_url": "",
              "profile_image": "https://res.cloudinary.com/...jpeg",
              "profile_image_90": "https://res.cloudinary.com/....jpeg"
            },
            "children": []
          }
        ]
      }
    ]
  end

  def response_stub
    {
      "data": {
        "id": "8",
        "type": "custom_activity",
        "attributes": {
          "action": "happened",
          "created_at": "2021-02-15T19:38:01.361Z",
          "key": "thing-123",
          "occurred_at": "2021-02-15T19:38:01.359Z",
          "updated_at": "2021-02-15T19:38:01.361Z",
          "type": "CustomActivity",
          "tags": [
            "product",
            "enterprise",
            "custom:custom-type",
            "custom:did-a-thing"
          ],
          "orbit_url": "http://localhost:3000/alejandrajenkinsdvm/activities/8",
          "custom_description": "More info about the thing",
          "custom_link": "http://link.com/",
          "custom_link_text": "See the thing",
          "custom_title": "Did a thing",
          "custom_type": "custom-type"
        },
        "relationships": {
          "activity_type": {
            "data": {
              "id": "8",
              "type": "activity_type"
            }
          },
          "member": {
            "data": {
              "id": "9",
              "type": "member"
            }
          },
          "user": {
            "data": {
              "id": "26",
              "type": "user"
            }
          }
        }
      },
      "included": [
        {
          "id": "8",
          "type": "activity_type",
          "attributes": {
            "name": "Something happened",
            "short_name": "Custom",
            "key": "custom:happened",
            "category": "custom",
            "weight": "1.0"
          }
        }
      ]
    }
  end

  def follower_response_stub
    {
      "data": {
        "id": "3283105",
        "type": "member",
        "attributes": {
          "activities_count": 0,
          "avatar_url": nil,
          "bio": nil,
          "birthday": nil,
          "company": nil,
          "created_at": "2021-04-11T14:19:33.981Z",
          "deleted_at": nil,
          "first_activity_occurred_at": nil,
          "id": 3_283_105,
          "last_activity_occurred_at": nil,
          "location": nil,
          "name": "Mrs. Neda Morissette",
          "orbit_level": nil,
          "pronouns": nil,
          "reach": nil,
          "shipping_address": nil,
          "slug": "nedamrsmorissette",
          "source": "api",
          "tag_list": [],
          "tags": [],
          "teammate": false,
          "tshirt": nil,
          "updated_at": "2021-04-11T14:19:34.117Z",
          "merged_at": nil,
          "url": "https://dev.to/nedamrsmorissette",
          "orbit_url": "https://app.orbit.love/test/members/nedamrsmorissette",
          "created": true,
          "love": 0.0,
          "twitter": nil,
          "github": nil,
          "discourse": nil,
          "email": nil,
          "devto": "nedamrsmorissette",
          "linkedin": nil,
          "github_followers": nil,
          "twitter_followers": nil,
          "topics": nil,
          "languages": nil
        },
        "relationships": {
          "identities": {
            "data": [
              {
                "id": "12",
                "type": "devto_identity"
              }
            ]
          }
        }
      },
      "included": [
        {
          "id": "12",
          "type": "devto_identity",
          "attributes": {
            "uid": nil,
            "email": nil,
            "username": "nedamrsmorissette",
            "name": nil,
            "source": "devto",
            "source_host": "dev.to"
          }
        }
      ]
    }
  end
end
