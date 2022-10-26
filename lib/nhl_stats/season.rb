module NHLStats
  class Season
    attr_reader :id, :start_date, :end_date, :playoffs_end_date, :game_count,
      :ties_allowed, :using_conferences, :using_divisions, :using_wild_card,
      :went_to_olympics

    def initialize(season_data)
      @id = season_data["seasonId"]
      @game_count = season_data["numberOfGames"]
      @ties_allowed = season_data["tiesInUse"]
      @using_conferences = season_data["conferencesInUse"]
      @using_divisions = season_data["divisionsInUse"]
      @using_wild_card = season_data["wildCardInUse"]
      @went_to_olympics = season_data["olympicsParticipation"]

      parse_dates(season_data)
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/seasons/#{id}")
      attributes = JSON.parse(response.body).dig("seasons", 0)
      new(attributes)
    end

    def self.current
      response = Faraday.get("#{API_ROOT}/seasons/current")
      attributes = JSON.parse(response.body).dig("seasons", 0)
      new(attributes)
    end

    def self.list
      response = Faraday.get("#{API_ROOT}/seasons")
      JSON.parse(response.body).
        fetch("seasons", []).
        map { |s| new(s) }
    end

    private

    def parse_dates(season_data)
      @start_date = DateTime.parse(season_data["regularSeasonStartDate"]).to_date
      @end_date = DateTime.parse(season_data["regularSeasonEndDate"]).to_date
      @playoffs_end_date = DateTime.parse(season_data["seasonEndDate"]).to_date
    end
  end
end
