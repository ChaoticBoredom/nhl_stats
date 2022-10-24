require "nhl_stats/version"
require "nhl_stats/conference"
require "nhl_stats/division"
require "nhl_stats/franchise"
require "nhl_stats/game"
require "nhl_stats/player"
require "nhl_stats/team"
require "nhl_stats/schedule"

require "faraday"
require "json"
require "time"

API_ROOT = "https://statsapi.web.nhl.com/api/v1".freeze

module NHLStats
  class Error < StandardError; end
end
