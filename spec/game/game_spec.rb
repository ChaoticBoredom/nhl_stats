RSpec.describe NHLStats::Game do
  it "should exist" do
    expect NHLStats::Game
  end

  describe "#home_team" do
    it "should return a single team" do
      VCR.use_cassette("game_home_team") do
        game = NHLStats::Game.find(2018021196)
        expect(game.home_team).to be_instance_of(NHLStats::Team)
      end
    end

    it "should return the home team" do
      VCR.use_cassette("game_home_team") do
        game = NHLStats::Game.find(2018021196)
        expect(game.home_team.name).to eq "San Jose Sharks"
      end
    end
  end

  describe "#away_team" do
    it "should return a single team" do
      VCR.use_cassette("game_away_team") do
        game = NHLStats::Game.find(2018021196)
        expect(game.away_team).to be_instance_of(NHLStats::Team)
      end
    end

    it "should return the away team" do
      VCR.use_cassette("game_away_team") do
        game = NHLStats::Game.find(2018021196)
        expect(game.away_team.name).to eq "Chicago Blackhawks"
      end
    end
  end

  describe "#away_team" do


  end

  describe ".find" do
    it "should return a single game" do
      VCR.use_cassette("single_game") do
        game = NHLStats::Game.find(2018021196)
        expect(game).to be_instance_of(NHLStats::Game)
      end
    end

    [
      {:field => :id, :value => 2018021196},
      {:field => :home_team_id, :value => 28},
      {:field => :away_team_id, :value => 16},
      {:field => :home_score, :value => 4},
      {:field => :away_score, :value => 5},
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_game") do
          game = NHLStats::Game.find(2018021196)
          expect(game.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end
end
