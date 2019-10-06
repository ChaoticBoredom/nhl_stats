RSpec.describe NHLStats::Team do
  it "should exist" do
    expect NHLStats::Team
  end

  describe "#current_roster" do
    it "should return an array of Players" do
      VCR.use_cassette("team_roster") do
        players = NHLStats::Team.find(20).current_roster
        expect(players).to all(be_instance_of(NHLStats::Player))
      end
    end

    context "when requested for an inactive team" do
      it "should not raise an error" do
        VCR.use_cassette("team_roster_inactive") do
          expect { NHLStats::Team.find(32).current_roster }.to_not raise_error
        end
      end

      it "should return nothing" do
        VCR.use_cassette("team_roster_inactive") do
          expect(NHLStats::Team.find(32).current_roster).to eq []
        end
      end
    end
  end

  describe "#roster_for_season" do
    it "should return an array of Players" do
      VCR.use_cassette("team_roster_for_1989") do
        players = NHLStats::Team.find(20).roster_for_season("19881989")
        expect(players).to all(be_instance_of(NHLStats::Player))
      end
    end

    it "should return the correct roster of Players" do
      VCR.use_cassette("team_roster_for_1989") do
        players = NHLStats::Team.find(20).roster_for_season("19881989")
        expect(players.map(&:full_name)).to match_array([
          "Al MacInnis", "Brad McCrimmon", "Brian Glynn", "Brian MacLellan",
          "Colin Patterson", "Dana Murzyn", "David Reierson", "Doug Gilmour",
          "Gary Roberts", "Gary Suter", "Hakan Loob", "Jamie Macoun",
          "Jim Peplinski", "Jiri Hrdina", "Joe Aloi", "Joe Mullen",
          "Joe Nieuwendyk", "Joel Otto", "Ken Sabourin", "Lanny McDonald",
          "Mark Hunter", "Mike Vernon", "Paul Ranheim", "Perry Berezan",
          "Ric Nattress", "Richard Chernomaz", "Rick Lessard", "Rick Wamsley",
          "Rob Ramage", "Sergei Priakin", "Shane Churla", "Stu Grimson",
          "Theo Fleury", "Tim Hunter"
        ])
      end
    end

    context "when requested for a season with no roster" do
      it "should not raise an error" do
        VCR.use_cassette("team_roster_non-existant") do
          expect { NHLStats::Team.find(54).roster_for_season("19881989") }.to_not raise_error
        end
      end

      it "should return nothing" do
        VCR.use_cassette("team_roster_non-existant") do
          expect(NHLStats::Team.find(54).roster_for_season("19881989")).to eq []
        end
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
      { :field => :id, :value => 20 },
      { :field => :name, :value => "Calgary Flames" },
      { :field => :abbreviation, :value => "CGY" },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_team") do
          team = NHLStats::Team.find(20)
          expect(team.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end

  describe ".list" do
    it "should return an array of teams" do
      VCR.use_cassette("list_teams") do
        teams = NHLStats::Team.list
        expect(teams).to all(be_instance_of(NHLStats::Team))
      end
    end

    it "should accept filters for a limited team" do
      VCR.use_cassette("list_teams_filtered") do
        teams = NHLStats::Team.list(:active => true)
        expect(teams.size).to eq 31
      end
    end
  end
end
