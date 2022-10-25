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

  describe "#team" do
    it "should return the team the player is on", :aggregate_failures do
      VCR.use_cassettes([{name: "single_player"}, {name: "single_team"}]) do
        player = NHLStats::Player.find(8479314)

        expect(NHLStats::Team).to receive(:find).with(player.team_id).and_call_original
        expect(player.team).to be_instance_of(NHLStats::Team)
        expect(player.team.id).to eq player.team_id
      end
    end
  end
end
