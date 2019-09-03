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
  
end
