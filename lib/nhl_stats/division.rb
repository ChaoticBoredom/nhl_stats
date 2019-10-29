module NHLStats
  class Division
    attr_reader :id, :name, :abbreviation

    def initialize(division_data)
      @id = division_data["id"]
      @name = division_data["name"]
      @abbreviation = division_data["nameShort"]
    end

    def self.find(id)

    end
  end
end
