require_relative 'test_helper'

describe "Hotel" do
  
  describe "initialize" do
    let(:hotel) {
      HotelBooking::Hotel.new(20, 200.00)
    }
    let(:room) {
      HotelBooking::Room.new(2)
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
      new_reservation = HotelBooking::Reservation.new(room, "september 1 2019", "september 5 2019")
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
  
  describe "#add_reservation" do
    let(:hotel) {
      HotelBooking::Hotel.new(20, 200.00)
    }
    let(:room) {
      HotelBooking::Room.new(1)
    }
    
    it "can add one new Reservation" do
      expect(hotel.reservations.length).must_equal 0
      new_reservation = HotelBooking::Reservation.new(room, "january 1, 2019", "january 3, 2019")
      hotel.add_reservation(new_reservation)
      expect(hotel.reservations.length).must_equal 1      
    end
    
    it "can add multiple new Reservations" do
      expect(hotel.reservations.length).must_equal 0
      first_reservation = HotelBooking::Reservation.new(room, "january 1, 2019", "january 3, 2019")
      second_reservation = HotelBooking::Reservation.new(room, "january 8, 2019", "january 12, 2019")
      hotel.add_reservation(first_reservation)
      hotel.add_reservation(second_reservation)
      expect(hotel.reservations.length).must_equal 2
    end
    
    it "raises an exception for an argument that isn't a Reservation" do
      new_reservation = "august 10th"
      expect {
        hotel.add_reservation(new_reservation)
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#make_reservation" do
    let(:hotel) {
      HotelBooking::Hotel.new(20, 200.00)
    }
    let(:new_reservation) {
      hotel.make_reservation("march 1 2019", "march 4 2019")
    }
    
    it "takes only two inputs, a start date and an end date" do
      expect {
        hotel.make_reservation(3, "march 1 2019", "march 4 2019")
      }.must_raise ArgumentError
    end
    
    it "raises an exception for invalid dates" do
      expect {
        hotel.make_reservation("cookie", "cereal")
      }.must_raise ArgumentError
    end
    
    it "instantiates a Reservation instance" do
      expect(new_reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    it "creates a Reservation with the right start_date" do
      expect(new_reservation.dates.start_date.to_s).must_equal "2019-03-01"
    end
    
    it "creates a Reservation with the right end_date" do
      expect(new_reservation.dates.end_date.to_s).must_equal "2019-03-04"
    end
    
    it "adds a Reservation to a Room's list" do
      expect(new_reservation.room.reservations).must_include new_reservation
    end
    
    it "adds a Reservation to the Hotel's list" do
      expect(hotel.reservations).must_include new_reservation
    end
  end
  
end
