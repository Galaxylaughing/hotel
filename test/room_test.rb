require_relative 'test_helper'

describe "Room" do
  
  describe "initialize" do
    let(:room) {
      HotelBooking::Room.new(1)
    }
    
    it "creates a Room Object" do
      expect(room).must_be_instance_of HotelBooking::Room
    end
    
    it "can read its room number" do
      expect(room.number).must_equal 1
    end
    
    it "will raise an exception if given an invalid room number" do
      expect {
        HotelBooking::Room.new("cookie")
      }.must_raise ArgumentError
    end
    
    it "must have a collection of reservations" do
      expect(room.reservations).must_be_instance_of Array
      room.reservations.each do |single_reservation|
        expect(single_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
    it "can add a Reservation to its list" do
      reservation_one = HotelBooking::Reservation.new(1, "august 1", "august 5")
      room.reservations << reservation_one
      expect(room.reservations.length).must_equal 1
    end
    
  end
  
  # describe "#add_reservation" do
  #   let(:room) {
  #     HotelBooking::Room.new(1)
  #   }
  
  
  # end
  
  describe "#is_available?" do
    let(:room) {
      HotelBooking::Room.new(19)
    }
    let(:date_range) {
      HotelBooking::DateRange.new("october 1 2019", "october 4 2019")      
    }
    
    it "is available if it has no reservations in its list" do
      expect(room.is_available?(date_range)).must_equal true
    end
    
    it "is available if none of its reservations overlap" do
      reservation_one = HotelBooking::Reservation.new(19, "august 1 2019", "august 8 2019")
      reservation_two = HotelBooking::Reservation.new(19, "august 12 2019", "august 14 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal true
    end
    
    it "is not available if it has a single overlapping reservation" do
      reservation_one = HotelBooking::Reservation.new(19, "august 1 2019", "august 8 2019")
      reservation_two = HotelBooking::Reservation.new(19, "october 2 2019", "october 6 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal false
    end
    
    it "is not available if it has multiple overlapping reservations" do
      reservation_one = HotelBooking::Reservation.new(19, "september 30 2019", "october 2 2019")
      reservation_two = HotelBooking::Reservation.new(19, "october 2 2019", "october 6 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal false
    end
    
  end
  
end
