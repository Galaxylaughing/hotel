require_relative 'test_helper'

describe "Reservation" do
  
  describe "initialize" do
    let(:reservation) {
      HotelBooking::Reservation.new(1, "august 1 2019", "august 3 2019", 200.00)
    }
    
    it "creates a Reservation Object" do
      expect(reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    # verifies initialized data was saved.
    it "can read its room number" do
      expect(reservation.room).must_equal 1
    end
    
    it "knows its price per night" do
      expect(reservation.cost_per_night).must_equal 200.00
    end
    
    it "has a DateRange" do
      expect(reservation.dates).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can read its DateRange start_date" do
      expect(reservation.dates.start_date.to_s).must_equal "2019-08-01"
    end
    
    it "can read its DateRange end_date" do
      expect(reservation.dates.end_date.to_s).must_equal "2019-08-03"
    end
    
  end
  
  describe "#total_cost" do
    let(:reservation_one) {
      HotelBooking::Reservation.new(1, "august 1 2019", "august 3 2019", 200.00)
    }
    let(:reservation_two) {
      HotelBooking::Reservation.new(1, "august 1 2019", "august 30 2019", 200.00)
    }
    
    it "returns a float" do
      expect(reservation_one.total_cost).must_be_instance_of Float
    end
    
    it "can total the cost for a short reservation" do
      expect(reservation_one.total_cost).must_equal 400.00
    end
    
    it "can total the cost for a long reservation" do
      expect(reservation_two.total_cost).must_equal 5_800.00
    end
    
  end
  
end
