require_relative 'test_helper'

describe "Reservation" do
  
  describe "initialize" do
    let(:room_one) {
      HotelBooking::Room.new(1)
    }
    let(:reservation) {
      HotelBooking::Reservation.new(room: room_one, start_date: "august 1 2019", end_date: "august 3 2019", cost_per_night: 200.00)
    }
    
    it "creates a Reservation Object" do
      expect(reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    it "raises an exception if handed a non-Room" do
      expect {
        HotelBooking::Reservation.new(room: 1, start_date: "august 1 2019", end_date: "august 3 2019", cost_per_night: 200.00)
      }.must_raise ArgumentError
    end
    
    # verifies initialized data was saved.
    it "can read its room number" do
      expect(reservation.room.number).must_equal 1
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
  
  
  describe "#make_dates" do
    let(:result) {
      HotelBooking::Reservation.make_dates(start_date: "august 1 2019", end_date: "august 3 2019")
    }
    
    it "returns a DateRange" do
      expect(result).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can access the start date" do
      expect(result.start_date.to_s).must_equal "2019-08-01"
    end
    
    it "can access the end date" do
      expect(result.end_date.to_s).must_equal "2019-08-03"
    end
    
    it "raises an exception is given invalid dates" do
      expect {
        HotelBooking::Reservation.make_dates(start_date: "cookie", end_date: "monster")
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#total_cost" do
    let(:room_one) {
      HotelBooking::Room.new(1)
    }
    let(:reservation_one) {
      HotelBooking::Reservation.new(room: room_one, start_date: "august 1 2019", end_date: "august 3 2019", cost_per_night: 200.00)
    }
    let(:reservation_two) {
      HotelBooking::Reservation.new(room: room_one, start_date: "august 1 2019", end_date: "august 30 2019", cost_per_night: 200.00)
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
