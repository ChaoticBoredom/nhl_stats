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
      { :field => :id, :value => 8_479_314 },
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
end
