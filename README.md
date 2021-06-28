# DEV.to Interactions to Orbit Workspace

![Build Status](https://github.com/orbit-love/community-ruby-dev-orbit/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/dev_orbit.svg)](https://badge.fury.io/rb/dev_orbit)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](code_of_conduct.md)

Add your DEV interactions into your Orbit workspace with this community-built integration.

![New DEV blog post comment in Orbit screenshot](readme-images/new-comment-screenshot.png)

|<p align="left">:sparkles:</p> This is a *community project*. The Orbit team does its best to maintain it and keep it up to date with any recent API changes.<br/><br/>We welcome community contributions to make sure that it stays current. <p align="right">:sparkles:</p>|
|-----------------------------------------|

![There are three ways to use this integration. Install package - build and run your own applications. Run the CLI - run on-demand directly from your terminal. Schedule an automation with GitHub - get started in minutes - no coding required](readme-images/ways-to-use.png)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dev_orbit'
```

## Usage

### Instantiation of the Client

To instantiate a DevOrbit client, you can either pass along your credentials for DEV and Orbit directly to the instantiation or retain them in your environment variables.

The following are the environment variables, you can provide either or both a `DEV_USERNAME` or a `DEV_ORGANIZATION`:

```ruby
ORBIT_API_KEY
ORBIT_WORKSPACE_ID
DEV_API_KEY
DEV_USERNAME
DEV_ORGANIZATION
```

With the credentials as environment variables:

```ruby
client = DevOrbit::Client.new
```

Passing in the credentials directly into the instantiation:

```ruby
client = DevOrbit::Client.new(
  orbit_api_key: '...',
  orbit_workspace: '...',
  dev_api_key: '...',
  dev_username: '...',
  dev_organization: '...'
)
```

### Performing a Historical Import

By default, the integration will only import comments that are newer than the newest DEV comment in your Orbit workspace. You may want to perform a one-time historical import to fetch all your previous DEV comments and bring them into your Orbit workspace. To do so, instantiate your `client` with the `historical_import` flag:

```ruby
client = DevOrbit::Client.new(
  historical_import: true
)
```
### Post New DEV Comments from a DEV User to Orbit Workspace

You can use the gem to get new DEV comments on your DEV user by invoking the `#comments` method on your `client` instance:

```ruby
client.comments
```

This method will fetch all your user articles from DEV, gather their respective comments, filter them for anything within the past day, and then send them to your Orbit workspace via the Orbit API.

### Post New DEV Comments from a DEV Organization to Orbit Workspace

You can use the gem to get new DEV comments on your DEV organization by invoking the `#comments` method on your `client` instance:

```ruby
client.organization_comments
```

This method will fetch all your organization articles from DEV, gather their respective comments, filter them for anything within the past day, and then send them to your Orbit workspace via the Orbit API.

### Post New DEV Followers to Orbit Workspace

You can use the gem to get new DEV followers by invoking the `#followers` method on your `client` instance:

```ruby
client.followers
```

You can run this either of those or any one of them as a daily cron job, for example, to add your newest DEV comments and/or followers as activities and members in your Orbit workspace.

### CLI

You can also use the built-in CLI to perform the following operations:

* Check for new DEV user comments and post them to Orbit

```bash
$ ORBIT_API_KEY='...' ORBIT_WORKSPACE='...' DEV_API_KEY='...' DEV_USERNAME='...' bundle exec dev_orbit --check-comments
```

* Check for new DEV user followers and post them to Orbit

```bash
$ ORBIT_API_KEY='...' ORBIT_WORKSPACE='...' DEV_API_KEY='...' DEV_USERNAME='...' bundle exec dev_orbit --check-followers
```

* Check for new DEV organization comments and post them to Orbit

```bash
$ ORBIT_API_KEY='...' ORBIT_WORKSPACE='...' DEV_API_KEY='...' DEV_ORGANIZATION='...' bundle exec dev_orbit --check-organization-comments
```
**Add the `--historical-import` flag to your CLI command to perform a historical import of all your DEV comments using the CLI.**

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/orbit-love/community-ruby-dev-orbit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/orbit-love/community-ruby-dev-orbit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/orbit-love/community-ruby-dev-orbit/blob/main/CODE_OF_CONDUCT.md).
