require_relative 'test_helper'

describe "DateFactory" do
  let(:date_factory) {
    HotelBooking::DateFactory.new()
  }
  let(:new_date) {
    date_factory.make_date("jan 1 2019")
  }
  
  describe "#make_date" do
    
    it "can create a Date instance" do
      expect(new_date).must_be_instance_of Date
    end
    
    it "can access the Date" do
      expect(new_date.to_s).must_equal "2019-01-01" 
    end
    
  end
  
end
