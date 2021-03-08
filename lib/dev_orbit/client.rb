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
# @option params [String] :orbit_workspace
#   The workspace ID for the Orbit workspace
#
# @option params [String] :orbit_api_key
#   The API key for the Orbit API
#
# @param [Hash] params
#
# @return [DevOrbit::Client]
#s
class DevOrbit::Client
  attr_accessor :dev_username, :dev_api_key, :orbit_workspace, :orbit_api_key

  def initialize(params = {})
    @orbit_api_key ||= params.fetch(:orbit_api_key, ENV['ORBIT_API_KEY'])
    @orbit_workspace ||= params.fetch(:orbit_workspace, ENV['ORBIT_WORKSPACE'])
    @dev_api_key ||= params.fetch(:dev_api_key, ENV['DEV_API_KEY'])
    @dev_username ||= params.fetch(:dev_username, ENV['DEV_USERNAME'])
  end

  # Fetch new comments from DEV and post them to the Orbit workspace
  def comments
    DevOrbit::Dev.new(
      api_key: @dev_api_key,
      username: @dev_username,
      workspace_id: @orbit_workspace,
      orbit_api_key: @orbit_api_key
    ).process_comments
  end

  def orbit
    DevOrbit::Orbit.new
  end
end