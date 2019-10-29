RSpec.describe NHLStats::Division do
  it "should exist" do
    expect NHLStats::Division
  end

  describe ".find" do
    it "should return a single division" do
      VCR.use_cassette("division/find") do
        division = NHLStats::Division.find(17)
        expect(division).to be_instance_of(NHLStats::Division)
      end
    end

    [
      { :field => :id, :value => 17 },
      { :field => :name, :value => "Atlantic" },
      { :field => :abbreviation, :value => "ATL"},
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("division/find") do
          division = NHLStats::Division.find(17)
          expect(division.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end
end
