RSpec.describe NHLStats::Schedule do
  it "should exist" do
    expect NHLStats::Schedule
  end

  describe ".find" do
    it "should return a single dates schedule" do
      VCR.use_cassette("schedule/find") do
        schedule = NHLStats::Schedule.find("2021-10-31")
        expect(schedule).to be_instance_of(NHLStats::Schedule)
      end
    end

    it "should return the correct value for date and games" do
      VCR.use_cassette("schedule/find") do
        schedule = NHLStats::Schedule.find("2021-10-31")
        expect(schedule.date).to eq "2021-10-31"
        expect(schedule.games.count).to eq 5
        expect(schedule.games).to all(be_instance_of(NHLStats::Game))
      end
    end
  end

  describe ".list" do
    it "should return an array of schedules" do
      VCR.use_cassette("schedule/list") do
        schedules = NHLStats::Schedule.list
        expect(schedules).to all(be_instance_of(NHLStats::Schedule))
      end
    end
  end
end
