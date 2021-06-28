# frozen_string_literal: true

# Create a client to log DEV interactions in your Orbit workspace
# Credentials can either be passed in to the instance or be loaded
# from environment variables
#
# @example
#   client = DevOrbit::Client.new
#
# @option params [String] :dev_username
#   The username of the person or organization to fetch DEV interactions for
#
# @option params [String] :dev_api_key
#   The API key for the DEV API
#
# @option params [String] :dev_organization
#   The name of the organization in DEV to fetch interactions for
#
# @option params [String] :orbit_workspace
#   The workspace ID for the Orbit workspace
#
# @option params [String] :orbit_api_key
#   The API key for the Orbit API
#
# @option params [Boolean] :historical_import
#   Perform a historical import on all DEV comments
#   Boolean, default to false
#
# @param [Hash] params
#
# @return [DevOrbit::Client]
#
module DevOrbit
  class Client
    attr_accessor :dev_username, :dev_api_key, :dev_organization, :orbit_workspace, :orbit_api_key, :historical_import

    def initialize(params = {})
      @orbit_api_key = params.fetch(:orbit_api_key, ENV["ORBIT_API_KEY"])
      @orbit_workspace = params.fetch(:orbit_workspace, ENV["ORBIT_WORKSPACE_ID"])
      @dev_api_key = params.fetch(:dev_api_key, ENV["DEV_API_KEY"])
      @dev_username = params.fetch(:dev_username, ENV["DEV_USERNAME"])
      @dev_organization = params.fetch(:dev_organization, ENV["DEV_ORGANIZATION"])
      @historical_import = params.fetch(:historical_import, false)
    end

    # Fetch new comments from DEV and post them to the Orbit workspace
    def comments(type: "user")
      DevOrbit::Dev.new(
        api_key: @dev_api_key,
        username: @dev_username,
        workspace_id: @orbit_workspace,
        orbit_api_key: @orbit_api_key,
        historical_import: @historical_import
      ).process_comments(type: type)
    end

    def followers
      DevOrbit::Dev.new(
        api_key: @dev_api_key,
        username: @dev_username,
        workspace_id: @orbit_workspace,
        orbit_api_key: @orbit_api_key
      ).process_followers
    end

    def organization_comments(type: "organization")
      DevOrbit::Dev.new(
        api_key: @dev_api_key,
        organization: @dev_organization,
        workspace_id: @orbit_workspace,
        orbit_api_key: @orbit_api_key
      ).process_comments(type: type)
    end

    def orbit
      DevOrbit::Orbit.new
    end
  end
end
