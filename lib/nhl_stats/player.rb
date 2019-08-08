require "faraday"
require "json"

API_URL = "https://statsapi.web.nhl.com/api/v1/people"

module NHLStats
  class Player
    attr_reader :id, :full_name, :first_name, :last_name, :number, :birth_date, :nationality, :active

    def initialize(attributes)
      player = attributes.dig("people", 0)
      @id = player["id"]
      @full_name = player["fullName"]
      @first_name = player["firstName"]
      @last_name = player["lastName"]
      @number = player["primaryNumber"].to_i
      @birth_date = Date.parse(player["birthDate"])
      @nationality = player["nationality"]
      @active = player["active"]
    end

    def self.find(id)
      response = Faraday.get("#{API_URL}/#{id}")
      attributes = JSON.parse(response.body)
      new(attributes)
    end
  end
end
