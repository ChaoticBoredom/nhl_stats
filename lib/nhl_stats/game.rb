module NHLStats
  class Game
    attr_reader :id, :home_team_id, :away_team_id, :home_score, :away_score, :date, :home_team_name, :away_team_name

    def initialize(game_data)
      @id = game_data[:id] || game_data["gamePk"]
      home_team_data(game_data)
      away_team_data(game_data)
      @date = Time.parse(game_data.dig("periods", 0, "startTime") || game_data["gameDate"])
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
      new(attributes.merge(:id => id))
    end

    def self.list(params = {})
      response = Faraday.get("#{API_ROOT}/schedule", params)
      JSON.parse(response.body).
        fetch("dates", []).
        map { |d| d.fetch("games", []).map { |g| NHLStats::Game.new(g) } }.
        flatten
    end

    private

    def home_team_data(game_data)
      home = game_data.dig("teams", "home")
      @home_team_id = home.dig("team", "id")
      @home_score = home["goals"] || home["score"]
      @home_team_name = home.dig("team", "name")
    end

    def away_team_data(game_data)
      away = game_data.dig("teams", "away")
      @away_team_id = away.dig("team", "id")
      @away_score = away["goals"] || away["score"]
      @away_team_name = away.dig("team", "name")
    end
  end
end
