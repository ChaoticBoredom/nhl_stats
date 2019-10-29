module NHLStats
  class Conference
    attr_reader :id, :name

    def initialize(conference_data)
    end

    def self.find(id)
      response = Faraday.get("#{API_ROOT}/conferences/#{id}")
      attributes = JSON.parse(response.body).dig("conferences", 0)
      new(attributes)
    end

    def self.list
      response = Faraday.get("#{API_ROOT}/conferences")
      JSON.parse(response.body).
        dig("conferences").
        map { |c| NHLStats::Conference.new(c) }
    end
  end
end
