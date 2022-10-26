RSpec.describe NHLStats::Season do
  it "should exist" do
    expect NHLStats::Season
  end

  describe ".find" do
    it "should return a single season" do
      VCR.use_cassette("single_season") do
        season = NHLStats::Season.find("20032004")
        expect(season).to be_instance_of(NHLStats::Season)
      end
    end

    [
      { :field => :id, :value => "20032004" },
      { :field => :game_count, :value => 82 },
      { :field => :ties_allowed, :value => true },
      { :field => :using_conferences, :value => true },
      { :field => :using_divisions, :value => true },
      { :field => :using_wild_card, :value => false },
      { :field => :went_to_olympics, :value => false },
      { :field => :start_date, :value => Date.new(2003, 10, 8) },
      { :field => :end_date, :value => Date.new(2004, 4, 4) },
      { :field => :playoffs_end_date, :value => Date.new(2004, 6, 7) },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_season") do
          season = NHLStats::Season.find("20032004")
          expect(season.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end

  describe ".current" do
    it "should return a single season" do
      VCR.use_cassette("current_season") do
        season = NHLStats::Season.current
        expect(season).to be_instance_of(NHLStats::Season)
      end
    end

    [
      { :field => :id, :value => "20222023" },
      { :field => :game_count, :value => 82 },
      { :field => :ties_allowed, :value => false },
      { :field => :using_conferences, :value => true },
      { :field => :using_divisions, :value => true },
      { :field => :using_wild_card, :value => true },
      { :field => :went_to_olympics, :value => false },
      { :field => :start_date, :value => Date.new(2022, 10, 7) },
      { :field => :end_date, :value => Date.new(2023, 4, 13) },
      { :field => :playoffs_end_date, :value => Date.new(2023, 6, 30) },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("current_season") do
          season = NHLStats::Season.current
          expect(season.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end

  describe ".list" do
    it "should return an array of seasons" do
      VCR.use_cassette("list_season") do
        seasons = NHLStats::Season.list
        expect(seasons).to all(be_instance_of(NHLStats::Season))
      end
    end
  end
end
