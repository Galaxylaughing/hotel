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
      room = HotelBooking::Room.new(1)
      reservation_one = HotelBooking::Reservation.new(room: room, start_date: "august 1", end_date: "august 5")
      room.reservations << reservation_one
      expect(room.reservations.length).must_equal 1
    end
    
  end
  
  describe "#add_reservation_to_list" do
    let(:room_one) {
      HotelBooking::Room.new(1)
    }
    let(:room_three) {
      HotelBooking::Room.new(3)
    }
    
    it "can add a new reservation" do
      new_reservation = HotelBooking::Reservation.new(room: room_one, start_date: "august 1", end_date: "august 5")
      
      room_one.add_reservation_to_list(new_reservation)
      expect(room_one.reservations.length).must_equal 1
    end
    
    it "raises an exception if handed a Reservation with a non-matching room number" do
      new_reservation = HotelBooking::Reservation.new(room: room_three, start_date: "august 1", end_date: "august 5")
      expect {
        room_one.add_reservation_to_list(new_reservation)
      }.must_raise ArgumentError
    end
    
    it "raises an exception for an argument that isn't a Reservation Object" do
      new_reservation = "august 10th"
      expect {
        room_one.add_reservation_to_list(new_reservation)
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#is_available?" do
    let(:room) {
      HotelBooking::Room.new(19)
    }
    let(:date_range) {
      HotelBooking::DateRange.new(start_date: "october 1 2019", end_date: "october 4 2019")      
    }
    
    it "is available if it has no reservations in its list" do
      expect(room.is_available?(date_range)).must_equal true
    end
    
    it "is available if none of its reservations overlap" do
      reservation_one = HotelBooking::Reservation.new(room: room, start_date: "august 1 2019", end_date: "august 8 2019")
      reservation_two = HotelBooking::Reservation.new(room: room, start_date: "august 12 2019", end_date: "august 14 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal true
    end
    
    it "is not available if it has a single overlapping reservation" do
      reservation_one = HotelBooking::Reservation.new(room: room, start_date: "august 1 2019", end_date: "august 8 2019")
      reservation_two = HotelBooking::Reservation.new(room: room, start_date: "october 2 2019", end_date: "october 6 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal false
    end
    
    it "is not available if it has multiple overlapping reservations" do
      reservation_one = HotelBooking::Reservation.new(room: room, start_date: "september 30 2019", end_date: "october 2 2019")
      reservation_two = HotelBooking::Reservation.new(room: room, start_date: "october 2 2019", end_date: "october 6 2019")
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(date_range)).must_equal false
    end
    
  end
  
end
