module NHLStats
  class Division
    attr_reader :id, :name, :abbreviation

    def initialize(division_data)
      @id = division_data["id"]
      @name = division_data["name"]
      @abbreviation = division_data["nameShort"]
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/divisions/#{id}")
      attributes = JSON.parse(response.body).dig("divisions", 0)
      new(attributes)
    end

    def self.list
      response = Faraday.get("#{API_ROOT}/divisions")
      JSON.parse(response.body).
        dig("divisions").
        map { |d| NHLStats::Division.new(d) }
    end
  end
end
