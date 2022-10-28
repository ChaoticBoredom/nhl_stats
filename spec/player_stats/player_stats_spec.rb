RSpec.describe NHLStats::PlayerStats do
  it "should exist" do
    expect NHLStats::PlayerStats
  end

  # This is a class that's primarily called via other classes,
  # so in testing we manually request the statline

  def fetch_player_stats(player_id, season_id)
    response = Faraday.get("#{API_ROOT}/people/#{player_id}/stats",
      :stats => "statsSingleSeason",
      :season => season_id)
    JSON.parse(response.body).dig("stats", 0, "splits", 0)
  end

  describe ".new" do
    def player_stats_attributes
      fetch_player_stats(8478233, "20212022")
    end

    it "should return a stat line" do
      VCR.use_cassette("current_stats") do
        player_stats = NHLStats::PlayerStats.new(player_stats_attributes)
        expect(player_stats).to be_instance_of(NHLStats::PlayerStats)
      end
    end

    [
      { :field => "season", :value => "20212022" },
      { :field => "time_on_ice", :value => "1289:37" },
      { :field => "assists", :value => 20 },
      { :field => "goals", :value => 35 },
      { :field => "pim", :value => 38 },
      { :field => "shots", :value => 185 },
      { :field => "games", :value => 82 },
      { :field => "hits", :value => 73 },
      { :field => "power_play_goals", :value => 8 },
      { :field => "power_play_points", :value => 11 },
      { :field => "power_play_time_on_ice", :value => "147:25" },
      { :field => "even_time_on_ice", :value => "1036:15" },
      { :field => "penalty_minutes", :value => "38" },
      { :field => "face_off_percent", :value => 38.18 },
      { :field => "shot_percent", :value => 18.9 },
      { :field => "game_winning_goals", :value => 8 },
      { :field => "over_time_goals", :value => 0 },
      { :field => "short_handed_goals", :value => 2 },
      { :field => "short_handed_points", :value => 3 },
      { :field => "short_handed_time_on_ice", :value => "105:57" },
      { :field => "blocked_shots", :value => 32 },
      { :field => "plus_minus", :value => 20 },
      { :field => "points", :value => 55 },
      { :field => "shifts", :value => 1804 },
      { :field => "time_on_ice_per_game", :value => "15:43" },
      { :field => "even_time_on_ice_per_game", :value => "12:38" },
      { :field => "short_handed_time_on_ice_per_game", :value => "01:17" },
      { :field => "power_play_time_on_ice_per_game", :value => "01:47" },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("current_stats") do
          player_stats = NHLStats::PlayerStats.new(player_stats_attributes)
          expect(player_stats.send(hash[:field])).to eq hash[:value]
        end
      end
    end

    context "with a very old statline" do
      def player_stats_attributes
        fetch_player_stats(8445131, "19211922")
      end

      it "should not throw an error" do
        VCR.use_cassette("old_stats") do
          expect { NHLStats::PlayerStats.new(player_stats_attributes) }.to_not raise_error
        end
      end

      [
        { :field => "season", :value => "19211922" },
        { :field => "time_on_ice", :value => nil },
        { :field => "assists", :value => 5 },
        { :field => "goals", :value => 1 },
        { :field => "pim", :value => 4 },
        { :field => "shots", :value => nil },
        { :field => "games", :value => 18 },
        { :field => "hits", :value => nil },
        { :field => "power_play_goals", :value => nil },
        { :field => "power_play_points", :value => nil },
        { :field => "power_play_time_on_ice", :value => nil },
        { :field => "even_time_on_ice", :value => nil },
        { :field => "penalty_minutes", :value => "4" },
        { :field => "face_off_percent", :value => nil },
        { :field => "shot_percent", :value => nil },
        { :field => "game_winning_goals", :value => 1 },
        { :field => "over_time_goals", :value => 0 },
        { :field => "short_handed_goals", :value => nil },
        { :field => "short_handed_points", :value => nil },
        { :field => "short_handed_time_on_ice", :value => nil },
        { :field => "blocked_shots", :value => nil },
        { :field => "plus_minus", :value => nil },
        { :field => "points", :value => 6 },
        { :field => "shifts", :value => nil },
        { :field => "time_on_ice_per_game", :value => nil },
        { :field => "even_time_on_ice_per_game", :value => nil },
        { :field => "short_handed_time_on_ice_per_game", :value => nil },
        { :field => "power_play_time_on_ice_per_game", :value => nil },
      ].each do |hash|
        it "should return the correct value for #{hash[:field]}" do
          VCR.use_cassette("old_stats") do
            player_stats = NHLStats::PlayerStats.new(player_stats_attributes)
            expect(player_stats.send(hash[:field])).to eq hash[:value]
          end
        end
      end
    end
  end
end
