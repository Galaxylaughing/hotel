require_relative 'test_helper'

describe "DateRange" do
  
  describe "#initialize" do
    # let(:aug_first) {
    #   Date.parse("august 1 2019")
    # }
    # let(:aug_third) {
    #   Date.parse("august 3 2019")
    # }
    let(:daterange) {
      HotelBooking::DateRange.new("august 1 2019", "august 3 2019")
    }
    
    it "can create a DateRange Object" do
      expect(daterange).must_be_instance_of HotelBooking::DateRange
    end
    
    # verifies initialized data was saved.
    it "can read a start_date" do
      expect(daterange.start_date).must_equal "august 1 2019"
    end
    
    it "can read an end_date" do
      expect(daterange.end_date).must_equal "august 3 2019"
    end
    
    # verifies initialized data is the correct format.
    it "saves start_date as a Date Object" do
    end
    
    it "saves end_date as a Date Object" do
    end
    
  end
  
end

## DateRange notes

# You could have a DateRange class, an instance of which is assigned to each Reservation.
#  - (integer) start_date
#  - (integer) end_date

# + DateRange.initialize()
#   * inputs: start_date, end_date
#   * transforms intputs into Dates using DateRange.parse()

# + DateRange.is_valid?()
#   * inputs: start_date, end_date
#   * checks if date range is valid
#   *   (e.g. end_date is not before start_date, end_date and start_date aren't the same date)
#   * returns a boolean

# + DateRange.parse()
#   * inputs: a date
#   * transforms intputs into Dates using Date.parse()
#   * returns a Date

# + DateRange#how_many_nights?()
#   * inputs: none. called on a DateRange instance.
#   * returns (integer) num_of_nights

# what about a DateRange#overlaps?(other_daterange) method?