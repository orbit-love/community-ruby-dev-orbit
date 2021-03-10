# DEV.to Interactions to Orbit Workspace

![Build Status](https://github.com/bencgreenberg/dev_orbit/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/dev_orbit.svg)](https://badge.fury.io/rb/dev_orbit)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](code_of_conduct.md)

This is a Ruby gem that can be used to integrate your DEV interactions, like DEV comments on blog posts, into your organization's Orbit workspace.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dev_orbit'
```

## Usage

### Instantiation of the Client

To instantiate a DevOrbit client, you can either pass along your credentials for DEV and Orbit directly to the instantiation or retain them in your environment variables.

The following are the expected environment variables:

```ruby
ORBIT_API_KEY
ORBIT_WORKSPACE_ID
DEV_API_KEY
DEV_USERNAME
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
  dev_username: '...'
)
```

### Post New DEV Comments to Orbit Workspace

You can use the gem to get new DEV comments on your DEV user or organization by invoking the `#comments` method on your `client` instance:

```ruby
client.comments
```

This method will fetch all your articles from DEV, gather their respective comments, filter them for anything within the past day, and then send them to your Orbit workspace via the Orbit API.

You can run this a daily cron job, for example, to add your newest DEV comments as activities in your Orbit workspace.

### CLI

You can also use the built-in CLI to perform the following operations:

* Check for new DEV comments and post them to Orbit

```bash
$ ORBIT_API_KEY='...' ORBIT_WORKSPACE='...' DEV_API_KEY='...' DEV_USERNAME='...' bundle exec dev_orbit --check-comments
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bencgreenberg/dev_orbit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bencgreenberg/dev_orbit/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bencgreenberg/dev_orbit/blob/master/CODE_OF_CONDUCT.md).
