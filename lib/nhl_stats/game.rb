module NHLStats
  class Game
    attr_reader :id, :home_team_id, :away_team_id, :home_score, :away_score, :date, :home_team_name, :away_team_name

    def initialize(game_data)
      @id = game_data[:id] || game_data["gamePk"]
      team_data(game_data, team: "home")
      team_data(game_data, team: "away")
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
      Schedule.list(params).flat_map(&:games)
    end

    private

    def team_data(game_data, team:)
      team_data = game_data.dig("teams", team)
      instance_variable_set("@#{team}_team_id", team_data.dig("team", "id"))
      instance_variable_set("@#{team}_score", team_data["goals"] || team_data["score"])
      instance_variable_set("@#{team}_team_name", team_data.dig("team", "name"))
    end
  end
end
