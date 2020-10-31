module NHLStats
  class Franchise
    attr_reader :id, :team_name, :location, :most_recent_team_id, :first_season, :last_season

    def initialize(franchise_data)
      @id = franchise_data[:id] || franchise_data.dig("franchiseId")
      @most_recent_team_id = franchise_data["mostRecentTeamId"]
      @location = franchise_data["locationName"]
      @team_name = franchise_data["teamName"]
      @first_season = franchise_data["firstSeasonId"]
      @last_season = franchise_data["lastSeasonId"]
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/franchises/#{id}")
      attributes = JSON.parse(response.body).dig("franchises", 0)
      new(attributes.merge(:id => id))
    end

    def self.list(params = {})
    end
  end
end
