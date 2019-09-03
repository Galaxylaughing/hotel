require_relative 'test_helper'

describe "DateRange" do
  
  describe ".initialize" do
    let(:aug_first) {
      Date.parse("august 1 2019")
    }
    let(:aug_third) {
      Date.parse("august 3 2019")
    }
    let(:daterange) {
      HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
    }
    
    it "can create a DateRange Object" do
      expect(daterange).must_be_instance_of HotelBooking::DateRange
    end
    
    # verifies initialized data was saved.
    it "can read a start_date" do
      expect(daterange.start_date).must_equal aug_first
    end
    
    it "can read an end_date" do
      expect(daterange.end_date).must_equal aug_third
    end
    
    # verifies initialized data is the correct format.
    it "saves start_date as a Date Object" do
      expect(daterange.start_date).must_be_instance_of Date
    end
    
    it "saves end_date as a Date Object" do
      expect(daterange.end_date).must_be_instance_of Date
    end
    
    # verifies constructor won't permit invalid inputs
    it "raises an exception for invalid ranges" do
      expect {
        HotelBooking::DateRange.new("august 3 2019", "august 1 2019")
      }.must_raise ArgumentError
    end
    
    # confirms that Date will execute an "invalid date" ArgumentError
    it "raises an exception if inputs cannot be parsed into dates" do
      expect {
        HotelBooking::DateRange.new("cookie", "chocolate chip")
      }.must_raise ArgumentError
    end
  end
  
  describe ".is_valid?" do
    let(:aug_first) {
      Date.parse("august 1 2019")
    }
    let(:aug_third) {
      Date.parse("august 3 2019")
    }
    
    it "returns true if given valid dates" do
      result = HotelBooking::DateRange.is_valid?(aug_first, aug_third)
      expect(result).must_equal true
    end
    
    it "returns false if the start_date and end_date are the same" do
      result = HotelBooking::DateRange.is_valid?(aug_first, aug_first)
      expect(result).must_equal false
    end
    
    it "returns false if the end_date precedes the start_date" do
      result = HotelBooking::DateRange.is_valid?(aug_third, aug_first)
      expect(result).must_equal false
    end
  end
  
end

## DateRange notes

# + DateRange#how_many_nights?()
#   * inputs: none. called on a DateRange instance.
#   * returns (integer) num_of_nights

# what about a DateRange#overlaps?(other_daterange) method?