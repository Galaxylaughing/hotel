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
    
    it "can read nights" do
      expect(daterange.nights).must_equal 2
    end
    
    # verifies initialized data is the correct format.
    it "saves start_date as a Date Object" do
      expect(daterange.start_date).must_be_instance_of Date
    end
    
    it "saves end_date as a Date Object" do
      expect(daterange.end_date).must_be_instance_of Date
    end
    
    it "saves nights as an Integer" do
      expect(daterange.nights).must_be_instance_of Integer
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
  
  describe ".count_nights" do
    let(:aug_first) {
      Date.parse("august 1 2019")
    }
    let(:aug_second) {
      Date.parse("august 2 2019")
    }
    let(:aug_third) {
      Date.parse("august 3 2019")
    }
    let(:aug_ninth) {
      Date.parse("august 9 2019")
    }
    
    it "returns one if given a range with one night" do
      one_night = HotelBooking::DateRange.count_nights(aug_first, aug_second)
      expect(one_night).must_equal 1
    end
    
    it "returns two if given a range with two nights" do
      two_nights = HotelBooking::DateRange.count_nights(aug_first, aug_third)
      expect(two_nights).must_equal 2
    end
    
    it "returns eight if given a range with eight nights" do
      eight_nights = HotelBooking::DateRange.count_nights(aug_first, aug_ninth)
      expect(eight_nights).must_equal 8
    end
    
  end
  
  describe "#overlaps?" do
    
    it "returns false for date ranges that do not overlap" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      other_range = HotelBooking::DateRange.new("august 5 2019", "august 9 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
    it "returns false if one range starts on the same day the other ends" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      other_range = HotelBooking::DateRange.new("august 3 2019", "august 9 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
    it "returns true for date ranges that overlap on two days" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      other_range = HotelBooking::DateRange.new("august 2 2019", "august 4 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "returns true for date ranges that overlap on every day" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      other_range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "returns true for date ranges that overlap entirely except the first begins a day earlier" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 4 2019")
      other_range = HotelBooking::DateRange.new("august 2 2019", "august 4 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "returns true for date ranges that overlap entirely except the second begins a day earlier" do
      range = HotelBooking::DateRange.new("august 2 2019", "august 4 2019")
      other_range = HotelBooking::DateRange.new("august 1 2019", "august 4 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "returns true for date ranges that overlap entirely except the first ends a day later" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 4 2019")
      other_range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "returns true for date ranges that overlap entirely except the second ends a day later" do
      range = HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
      other_range = HotelBooking::DateRange.new("august 1 2019", "august 4 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
  end
  
end