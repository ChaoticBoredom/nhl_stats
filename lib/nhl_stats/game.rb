module NHLStats
  class Game
    attr_reader :id, :home_team_id, :away_team_id, :home_score, :away_score

    def initialize(game_data)
      @id = game_data[:id]
      @home_team_id = game_data.dig("teams", "home", "team", "id")
      @away_team_id = game_data.dig("teams", "away", "team", "id")
      @home_score = game_data.dig("teams", "home", "teamStats", "teamSkaterStats", "goals")
      @away_score = game_data.dig("teams", "away", "teamStats", "teamSkaterStats", "goals")
    end

    def home_team
      NHLStats::Team.find(home_team_id)
    end

    def away_team
      NHLStats::Team.find(away_team_id)
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/game/#{id}/boxscore")
      attributes = JSON.parse(response.body)
      new(attributes.merge({:id => id}))
    end
  end
end
