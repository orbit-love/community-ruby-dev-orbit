# frozen_string_literal: true

require "zeitwerk"

module DevOrbit
  loader = Zeitwerk::Loader.new
  loader.tag = File.basename(__FILE__, ".rb")
  loader.push_dir(__dir__)
  loader.setup
end
