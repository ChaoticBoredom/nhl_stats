module NHLStats
  class Conference
    attr_reader :id, :name

    def initialize(conference_data)
      @id = conference_data["id"]
      @name = conference_data["name"]
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/conferences/#{id}")
      attributes = JSON.parse(response.body).dig("conferences", 0)
      new(attributes)
    end

    def self.list
      response = Faraday.get("#{API_ROOT}/conferences")
      JSON.parse(response.body).
        fetch("conferences", []).
        map { |c| NHLStats::Conference.new(c) }
    end
  end
end
