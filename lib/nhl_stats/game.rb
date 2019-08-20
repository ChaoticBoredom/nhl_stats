module NHLStats
  class Game
    attr_reader :id, :home_team_id, :away_team_id, :home_score, :away_score, :date

    def initialize(game_data)
      @id = game_data[:id] || game_data.dig("gamePk")
      home = game_data.dig("teams", "home")
      away = game_data.dig("teams", "away")
      @home_team_id = home.dig("team", "id")
      @away_team_id = away.dig("team", "id")
      @home_score = home.dig("goals") || home.dig("score")
      @away_score = away.dig("goals") || away.dig("score")
      @date = Time.parse(game_data.dig("periods", 0, "startTime") || game_data.dig("gameDate"))
    end

    def home_team
      NHLStats::Team.find(home_team_id)
    end

    def away_team
      NHLStats::Team.find(away_team_id)
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/game/#{id}/linescore")
      attributes = JSON.parse(response.body)
      new(attributes.merge({:id => id}))
    end

    def self.list(params = {})
      response = Faraday.get("#{API_ROOT}/schedule", params)
      JSON.parse(response.body).
        fetch("dates", []).
        map { |d| d.fetch("games", []).map { |g| NHLStats::Game.new(g) } }.
        flatten
    end
  end
end
