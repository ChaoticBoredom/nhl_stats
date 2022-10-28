RSpec.describe NHLStats::Player do
  it "should exist" do
    expect NHLStats::Player
  end

  describe ".find" do
    it "should return a single player" do
      VCR.use_cassette("single_player") do
        player = NHLStats::Player.find(8479314)
        expect(player).to be_instance_of(NHLStats::Player)
      end
    end

    [
      { :field => :id, :value => 8479314 },
      { :field => :full_name, :value => "Matthew Tkachuk" },
      { :field => :first_name, :value => "Matthew" },
      { :field => :last_name, :value => "Tkachuk" },
      { :field => :number, :value => 19 },
      { :field => :birth_date, :value => Date.new(1997, 12, 11) },
      { :field => :nationality, :value => "USA" },
      { :field => :active, :value => true },
      { :field => :position, :value => "LW" },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_player") do
          player = NHLStats::Player.find(8479314)
          expect(player.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end

  describe "#season_stats" do
    it "should return an instance of PlayerStats" do
      VCR.use_cassette("single_player_season_stats") do
        player = NHLStats::Player.find(8478233)
        expect(player.season_stats("20212022")).to be_instance_of(NHLStats::PlayerStats)
      end
    end

    it "should return an instance of PlayerStats for the specified season" do
      VCR.use_cassette("single_player_season_stats") do
        player = NHLStats::Player.find(8478233)
        season_stats = player.season_stats("20212022")
        expect(season_stats.season).to eq "20212022"
      end
    end
  end

  describe "#current_season_stats" do
    it "should return an instance of PlayerStats" do
      VCR.use_cassette("current_season_stats") do
        player = NHLStats::Player.find(8478233)
        expect(player.current_season_stats).to be_instance_of(NHLStats::PlayerStats)
      end
    end

    it "should return an instance of PlayerStats for the specified season" do
      VCR.use_cassette("current_season_stats") do
        player = NHLStats::Player.find(8478233)
        season_stats = player.current_season_stats
        expect(season_stats.season).to eq NHLStats.current_season_id
      end
    end
  end
end
