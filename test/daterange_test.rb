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
      HotelBooking::DateRange.new(start_date: "august 1 2019", end_date: "august 3 2019")
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
        HotelBooking::DateRange.new(start_date: "august 3 2019", end_date: "august 1 2019")
      }.must_raise ArgumentError
    end
    
    # confirms that Date will execute an "invalid date" ArgumentError
    it "raises an exception if inputs cannot be parsed into dates" do
      expect {
        HotelBooking::DateRange.new(start_date: "cookie", end_date: "chocolate chip")
      }.must_raise ArgumentError
    end
  end
  
  describe ".make_date" do
    let(:result) {
      HotelBooking::DateRange.make_date("august 1 2019")
    }
    
    it "returns a Date instance" do
      expect(result).must_be_instance_of Date
    end
    
    it "does not attempt to convert Dates into Dates" do
      march_twenty = Date.parse("march 20 2019")
      
      #it shouldn't throw an exception
      result = HotelBooking::DateRange.make_date(march_twenty)
      expect(result).must_be_instance_of Date
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
      result = HotelBooking::DateRange.is_valid?(start_date: aug_first, end_date: aug_third)
      expect(result).must_equal true
    end
    
    it "returns false if the start_date and end_date are the same" do
      result = HotelBooking::DateRange.is_valid?(start_date: aug_first, end_date: aug_first)
      expect(result).must_equal false
    end
    
    it "returns false if the end_date precedes the start_date" do
      result = HotelBooking::DateRange.is_valid?(start_date: aug_third, end_date: aug_first)
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
      one_night = HotelBooking::DateRange.count_nights(start_date: aug_first, end_date: aug_second)
      expect(one_night).must_equal 1
    end
    
    it "returns two if given a range with two nights" do
      two_nights = HotelBooking::DateRange.count_nights(start_date: aug_first, end_date: aug_third)
      expect(two_nights).must_equal 2
    end
    
    it "returns eight if given a range with eight nights" do
      eight_nights = HotelBooking::DateRange.count_nights(start_date: aug_first, end_date: aug_ninth)
      expect(eight_nights).must_equal 8
    end
    
  end
  
  describe "#overlaps?" do
    
    # does overlap test cases
    it "overlaps if the date ranges are the same" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 10 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "overlaps if second range is contained within the first" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 7 2019", end_date: "august 10 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "overlaps if the second range begins before and ends during" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 1 2019", end_date: "august 6 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "overlaps if the second range begins during and ends after" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 11 2019", end_date: "august 15 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    it "overlaps if the second range begins before and ends after" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 1 2019", end_date: "august 15 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal true
    end
    
    # doesn't overlap test cases
    it "does NOT overlap if the second range begins after the first ends" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 13 2019", end_date: "august 15 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
    it "does NOT overlap if the second ends before the first begins" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 1 2019", end_date: "august 4 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
    # (if the 2nd ends when the 1st begins, the 1st begins on a new night from the 2nd)
    it "does NOT overlap if the second range ends when the first begins" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 1 2019", end_date: "august 5 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
    # (if the 2nd begins when the 1st ends, the 2nd begins on a new night from the 1st)
    it "does NOT overlap if the second range begins when the first ends" do
      range = HotelBooking::DateRange.new(start_date: "august 5 2019", end_date: "august 12 2019")
      other_range = HotelBooking::DateRange.new(start_date: "august 12 2019", end_date: "august 14 2019")
      
      result = range.overlaps?(other_range)
      expect(result).must_equal false
    end
    
  end
  
end
