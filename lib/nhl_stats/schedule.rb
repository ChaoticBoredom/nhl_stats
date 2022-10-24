module NHLStats
  class Schedule
    attr_reader :date, :games

    def initialize(data)
      @date = data["date"]
      @games = (data["games"] || []).map { |game| Game.new(game) }
    end

    def self.find(date)
      response = Faraday.get("#{API_ROOT}/schedule", date: date)
      schedule_data = JSON.parse(response.body).dig("dates", 0)
      new(schedule_data)
    end

    def self.list(params = {})
      response = Faraday.get("#{API_ROOT}/schedule", params)
      JSON.parse(response.body).fetch("dates", []).map do |data|
        new(data)
      end
    end
  end
end
