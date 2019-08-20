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

  describe ".find" do
    it "should return a single game" do
      VCR.use_cassette("single_game") do
        game = NHLStats::Game.find(2018021196)
        expect(game).to be_instance_of(NHLStats::Game)
      end
    end

    [
      { :field => :id, :value => 2018021196 },
      { :field => :home_team_id, :value => 28 },
      { :field => :away_team_id, :value => 16 },
      { :field => :home_score, :value => 4 },
      { :field => :away_score, :value => 5 },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_game") do
          game = NHLStats::Game.find(2018021196)
          expect(game.send(hash[:field])).to eq hash[:value]
        end
      end
    end

    it "should return the the correct start time" do
      VCR.use_cassette("single_game") do
        game = NHLStats::Game.find(2018021196)
        expect(game.date).to be_within(3600).of(Time.new(2018, 3, 29, 2))
      end
    end
  end

  describe ".list" do
    it "should return an array of games" do
      VCR.use_cassette("list_games") do
        games = NHLStats::Game.list
        expect(games).to all( be_instance_of(NHLStats::Game) )
      end
    end

    it "should accept filters for a limited set of games" do
      VCR.use_cassette("list_games_filtered") do
        games = NHLStats::Game.list(
          :startDate => "2019-03-14",
          :endDate => "2019-03-21"
        )
        expect(games.size).to eq 65
      end
    end

    [
      {:field => :id, :value => 2018021201},
      {:field => :home_team_id, :value => 20},
      {:field => :away_team_id, :value => 24},
      {:field => :home_score, :value => 6},
      {:field => :away_score, :value => 1},
      {:field => :date, :value => DateTime.new(2019, 3, 29)},
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("list_games_filtered_values") do
          games = NHLStats::Game.list(:teamId => 24, :date => Date.new(2019, 3, 29).to_s)
          expect(games.first.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end
end
