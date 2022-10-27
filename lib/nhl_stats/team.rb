module NHLStats
  class Team
    attr_reader :id, :name, :abbreviation

    def initialize(team_data)
      @id = team_data["id"]
      @name = team_data["name"]
      @abbreviation = team_data["abbreviation"]
    end

    def current_roster
      response = Faraday.get("#{API_ROOT}/teams/#{id}/roster")
      roster_response_to_players(response)
    end

    def roster_for_season(season)
      response = Faraday.get("#{API_ROOT}/teams/#{id}/roster", :season => season)
      roster_response_to_players(response)
    end

    def next_game
      retrieve_game_data("next")
    end

    def previous_game
      retrieve_game_data("previous")
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/teams/#{id}")
      attributes = JSON.parse(response.body).dig("teams", 0)
      new(attributes)
    end

    def self.list(params = {})
      response = Faraday.get("#{API_ROOT}/teams", params)
      JSON.parse(response.body).
        fetch("teams", []).
        map { |t| NHLStats::Team.new(t) }
    end

    private

    def roster_response_to_players(response)
      JSON.parse(response.body).fetch("roster", []).map do |p_data|
        attributes = p_data.delete("person").merge(p_data)
        attributes["currentTeam"] = { "id" => id }
        NHLStats::Player.new(attributes)
      end
    end

    def retrieve_game_data(direction = "next")
      response = Faraday.get("#{API_ROOT}/teams/#{id}", expand: "team.schedule.#{direction}")
      dig_array = [
        "teams",
        0,
        "#{direction}GameSchedule",
        "dates",
        0,
        "games",
        0,
      ]

      game_data = JSON.parse(response.body).dig(*dig_array)
      return nil unless game_data

      NHLStats::Game.new(game_data)
    end
  end
end
