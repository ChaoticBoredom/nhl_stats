RSpec.describe NHLStats::Franchise do
  it "should exist" do
    expect NHLStats::Franchise
  end

  describe "#most_recent_team" do
    it "should return a Team" do
      VCR.use_cassette("most_recent_team") do
        most_recent_team = NHLStats::Franchise.find(21).most_recent_team
        expect(most_recent_team).to be_instance_of(NHLStats::Team)
      end
    end
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

  describe ".list" do
    it "should return an array of franchises" do
      VCR.use_cassette("list_franchises") do
        franchises = NHLStats::Franchise.list
        expect(franchises).to all(be_instance_of(NHLStats::Franchise))
      end
    end

    it "should accept filters for a limited list" do
      VCR.use_cassette("list_franchises_filtered") do
        franchises = NHLStats::Franchise.list(:franchiseId => "2, 3, 5")
        expect(franchises.size).to eq 3
      end
    end
  end
end
