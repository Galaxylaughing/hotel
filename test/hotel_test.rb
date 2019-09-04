require_relative 'test_helper'

describe "Hotel" do
  
  describe "initialize" do
    let(:hotel) {
      HotelBooking::Hotel.new(20, 200.00)
    }
    
    it "can create a Hotel Object" do
      expect(hotel).must_be_instance_of HotelBooking::Hotel
    end
    
    # verifies initialized data was saved.
    it "can read its number of rooms" do
      expect(hotel.room_total).must_be_instance_of Integer
      expect(hotel.room_total).must_equal 20
    end
    
    it "can read its cost per night" do
      expect(hotel.cost_per_night).must_be_instance_of Float
      expect(hotel.cost_per_night).must_equal 200.00
    end
    
    it "has a collection of Reservations" do
      expect(hotel.reservations).must_be_instance_of Array
      hotel.reservations.each do |single_reservation|
        expect(single_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
    it "can add a Reservation to its list" do
      new_reservation = HotelBooking::Reservation.new(2, "september 1 2019", "september 5 2019")
      hotel.reservations << new_reservation
      expect(hotel.reservations.length).must_equal 1
    end
    
    it "has a collection of Rooms" do
      expect(hotel.rooms).must_be_instance_of Array
      hotel.rooms.each do |single_room|
        expect(single_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    # not sure how to implement this feature in hotel.rb
    # it "cannot add a room to its collection of Rooms" do
    #   new_room = HotelBooking::Room.new(1)
    #   expect {
    #     hotel.rooms << new_room
    #   }.must_raise ArgumentError
    # end
    
  end
  
  describe ".load_rooms" do
    let(:hotel) {
      HotelBooking::Hotel.new(20, 200.00)
    }
    
    it "creates an collection of Rooms" do
      new_rooms = hotel.load_rooms(20)
      expect(new_rooms).must_be_instance_of Array
      new_rooms.each do |single_room|
        expect(single_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    # for loop automatically raises an ArgumentError "bad value for range"
    it "raises an exception if not given a valid integer" do
      expect {
        hotel.load_rooms("20")
      }.must_raise ArgumentError
    end
    
  end
  
end