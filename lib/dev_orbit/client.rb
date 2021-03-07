# frozen_string_literal: true

class DevOrbit::Client
  attr_accessor :dev_username, :dev_api_key, :orbit_workspace, :orbit_api_key

  def initialize(params = {})
    @orbit_api_key ||= params.fetch(:orbit_api_key, ENV['ORBIT_API_KEY'])
    @orbit_workspace ||= params.fetch(:orbit_workspace, ENV['ORBIT_WORKSPACE'])
    @dev_api_key ||= params.fetch(:dev_api_key, ENV['DEV_API_KEY'])
    @dev_username ||= params.fetch(:dev_username, ENV['DEV_USERNAME'])
  end

  def comments
    DevOrbit::Dev.new(api_key: @dev_api_key, username: @dev_username).process_comments
  end

  def orbit
    DevOrbit::Orbit.new
  end
end