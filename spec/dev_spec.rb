# frozen_string_literal: true

require "spec_helper"

RSpec.describe DevOrbit::Dev do
  let(:subject) do
    DevOrbit::Dev.new(
      api_key: "12345",
      username: "test",
      workspace_id: "test",
      orbit_api_key: "12345"
    )
  end

  describe "#process_comments" do
    it "posts comments to the Orbit workspace from DEV" do
      stub_request(:get, "https://dev.to/api/articles?top=1&username=test").to_return(status: 200)
      stub_request(:get, "https://dev.to/api/comments?a_id=123").to_return(status: 200)
      stub_request(:post, "https://app.orbit.love/api/v1/test/activities").to_return(status: 200)
      allow(subject).to receive(:get_articles).and_return(article_stub)
      allow(subject).to receive(:get_article_comments).and_return(comment_stub)
      allow(DevOrbit::Orbit).to receive(:call).and_return(response_stub)
      allow(Time).to receive(:now).and_return("2021-03-08 15:07:55.2196 +0200")

      subject.process_comments
    end
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
end
