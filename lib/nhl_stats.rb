require "nhl_stats/version"
require "nhl_stats/player"
require "nhl_stats/team"

require "faraday"
require "json"

API_ROOT = "https://statsapi.web.nhl.com/api/v1"

module NHLStats
  class Error < StandardError; end
end
