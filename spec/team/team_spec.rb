RSpec.describe NHLStats::Team do
  it "should exist" do
    expect NHLStats::Team
  end

  describe "#current_roster" do
    it "should return an array of Players" do
      VCR.use_cassette("team_roster") do
        players = NHLStats::Team.find(20).current_roster
        expect(players).to all( be_instance_of(NHLStats::Player) )
      end
    end
  end

  describe ".find" do
    it "should return a single team" do
      VCR.use_cassette("single_team") do
        team = NHLStats::Team.find(20)
        expect(team).to be_instance_of(NHLStats::Team)
      end
    end

    [
      {:field => :id, :value => 20},
      {:field => :name, :value => "Calgary Flames"},
      {:field => :abbreviation, :value => "CGY"},
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_team") do
          team = NHLStats::Team.find(20)
          expect(team.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end
end
