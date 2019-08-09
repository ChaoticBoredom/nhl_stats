module NHLStats
  class Player
    attr_reader :id, :full_name, :first_name, :last_name, :number, :birth_date,
      :nationality, :active, :position

    def initialize(player_data)
      @id = player_data["id"]
      @full_name = player_data["fullName"]
      @first_name = player_data["firstName"]
      @last_name = player_data["lastName"]
      @number = player_data["primaryNumber"].to_i
      @birth_date = Date.parse(player_data["birthDate"])
      @nationality = player_data["nationality"]
      @active = player_data["active"]
      @position = player_data.dig("primaryPosition", "abbreviation")
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/people/#{id}")
      attributes = JSON.parse(response.body).dig("people", 0)
      new(attributes)
    end
  end
end
