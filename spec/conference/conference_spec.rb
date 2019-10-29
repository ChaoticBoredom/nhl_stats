RSpec.describe NHLStats::Conference do
  it "should exist" do
    expect NHLStats::Conference
  end

  describe ".find" do
    it "should return a single conference" do
      VCR.use_cassette("conference/find") do
        conference = NHLStats::Conference.find(5)
        expect(conference).to be_instance_of(NHLStats::Conference)
      end
    end

    [
      { :field => :id, :value => 5 },
      { :field => :name, :value => "Western" },
    ].each do |hash|
      it "should return the correct value for #{hash[:field]}" do
        VCR.use_cassette("conference/find") do
          conference = NHLStats::Conference.find(5)
          expect(conference.send(hash[:field])).to eq hash[:value]
        end
      end
    end
  end

  describe ".list" do
    it "should return an array of conferences" do
      VCR.use_cassette("conference/list") do
        conferences = NHLStats::Conference.list
        expect(conferences).to all(be_instance_of(NHLStats::Conference))
      end
    end
  end
end
