RSpec.describe NHLStats::Franchise do
  it "should exist" do
    expect NHLStats::Franchise
  end

  describe ".find" do
    it "should return a single franchise" do
      VCR.use_cassette("single_franchise") do
        franchise = NHLStats::Franchise.find(2)
        expect(franchise).to be_instance_of(NHLStats::Franchise)
      end
    end

    [
      { :field => :id, :value => 2 },
      { :field => :team_name, :value => "Wanderers" },
      { :field => :location, :value => "Montreal" },
      { :field => :most_recent_team_id, :value => 41 },
      { :field => :first_season, :value => 19171918 },
      { :field => :last_season, :value => 19171918 },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("single_franchise") do
          franchise = NHLStats::Franchise.find(2)
          expect(franchise.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end
end
