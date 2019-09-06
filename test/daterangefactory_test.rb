require_relative 'test_helper'

describe "DateRangeFactory" do
  let(:daterange_factory) {
    HotelBooking::DateRangeFactory.new()
  }
  let(:new_daterange) {
    daterange_factory.make_daterange(start_date: "jan 1 2019", end_date: "jan 3 2019")
  }
  
  describe "#make_daterange" do
    
    it "can create a DateRange instance" do
      expect(new_daterange).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can access the DateRange's start date" do
      expect(new_daterange.start_date).must_be_instance_of Date 
      expect(new_daterange.start_date.to_s).must_equal "2019-01-01" 
    end
    
    it "can access the DateRange's end date" do
      expect(new_daterange.end_date).must_be_instance_of Date 
      expect(new_daterange.end_date.to_s).must_equal "2019-01-03" 
    end
    
  end
  
end