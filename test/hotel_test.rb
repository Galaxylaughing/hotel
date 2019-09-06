require_relative 'test_helper'

describe "Hotel" do
  let(:hotel) {
    HotelBooking::Hotel.new(number_of_rooms: 20, price_per_night: 200.00, max_rooms_per_block: 5)
  }
  let(:room_factory) {
    HotelBooking::RoomFactory.new()
  }
  let(:room_two) {
    HotelBooking::Room.new(2)
  }
  
  describe "initialize" do
    it "can create a Hotel Object" do
      expect(hotel).must_be_instance_of HotelBooking::Hotel
    end
    
    # verifies initialized data was saved.
    it "can read its number of rooms" do
      expect(hotel.room_total).must_be_instance_of Integer
      expect(hotel.room_total).must_equal 20
    end
    
    it "can read its price per night" do
      expect(hotel.price_per_night).must_be_instance_of Float
      expect(hotel.price_per_night).must_equal 200.00
    end
    
    it "has a collection of Reservations" do
      expect(hotel.reservations).must_be_instance_of Array
      hotel.reservations.each do |single_reservation|
        expect(single_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
    it "can add a Reservation to its list" do
      new_reservation = HotelBooking::Reservation.new(room: room_two, start_date: "september 1 2019", end_date: "september 5 2019")
      hotel.reservations << new_reservation
      expect(hotel.reservations.length).must_equal 1
    end
    
    it "has a collection of Rooms" do
      expect(hotel.rooms).must_be_instance_of Array
      hotel.rooms.each do |single_room|
        expect(single_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    it "has a max number of rooms it will allow a block to take" do
      expect(hotel.max_rooms_per_block).must_equal 5
    end
    
    it "has a collection of blocks" do
      expect(hotel.blocks).must_be_instance_of Array
      hotel.blocks.each do |hotel_block|
        expect(hotel_block).must_be_instance_of HotelBooking::Block
      end
    end
  end
  
  describe "#load_rooms" do
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
  
  describe "#load_default_block" do
    
    it "creates a new block" do
      hotel.load_default_block()
      
      expect(hotel.blocks.length).must_equal 1
    end
    
    it "creates a block with the id of zero" do
      hotel.load_default_block()
      
      expect(hotel.blocks.first).must_be_instance_of HotelBooking::Block
      expect(hotel.blocks.first.id).must_equal 0
    end
    
  end
  
  describe "#find_by_room_number" do
    it "returns a Room instance" do
      room = hotel.find_by_room_number(10)
      expect(room).must_be_instance_of HotelBooking::Room
    end
    
    it "can return the first Room" do
      room = hotel.find_by_room_number(1)
      expect(room.number).must_equal 1
    end
    
    it "can return the last Room" do
      room = hotel.find_by_room_number(20)
      expect(room.number).must_equal 20
    end
    
    it "raises an error for invalid room numbers" do
      expect {
        hotel.find_by_room_number(21)
      }.must_raise ArgumentError
    end
  end
  
  describe "#find_block_by_id" do
    let(:new_block) {
      HotelBooking::Block.new(id: 5, start_date: "feb 20 2019", end_date: "feb 28 2019", price_per_night: 175.00)
    }
    
    it "returns a Block instance" do
      hotel.blocks << new_block
      found_block = hotel.find_block_by_id(5)
      expect(found_block).must_be_instance_of HotelBooking::Block
    end
    
    it "raises an error for nonexistent block IDs" do
      expect {
        hotel.find_block_by_id(40)
      }.must_raise ArgumentError
    end
    
    it "raises an error for invalid block IDs" do
      expect {
        hotel.find_block_by_id("cookie")
      }.must_raise ArgumentError
    end
  end
  
  describe "#reserve_room" do
    let(:start_date) {
      "march 1 2019"
    }
    let(:end_date) {
      "march 4 2019"
    }
    let(:new_reservation) {
      hotel.reserve_room(start_date: start_date, end_date: end_date)
    }
    
    # tests regarding inputs
    it "takes only two inputs, a start date and an end date" do
      expect {
        hotel.reserve_room(3, start_date: start_date, end_date: end_date)
      }.must_raise ArgumentError
    end
    
    it "raises an exception for invalid dates" do
      expect {
        hotel.reserve_room(start_date: "cookie", end_date: "cereal")
      }.must_raise ArgumentError
    end
    
    # tests regarding finding an available room
    it "finds room one if room one is not reserved" do
      expect(new_reservation.room.number).must_equal 1
    end
    
    it "finds room two if room two is not reserved but room one is" do
      room = hotel.find_by_room_number(1)
      reservation = HotelBooking::Reservation.new(room: room, start_date: start_date, end_date: end_date)
      hotel.reservations << reservation
      room.reservations << reservation
      
      expect(new_reservation.room.number).must_equal 2
    end
    
    it "finds room twenty if all other rooms are reserved but it is not" do
      hotel.rooms.each do |hotel_room|
        if hotel_room.number != 20
          reservation = HotelBooking::Reservation.new(room: hotel_room, start_date: start_date, end_date: end_date)
          hotel.reservations << reservation
          hotel_room.reservations << reservation
        end
      end
      
      expect(new_reservation.room.number).must_equal 20
    end
    
    it "raises an exception if all rooms are reserved" do
      hotel.rooms.each do |hotel_room|
        reservation = HotelBooking::Reservation.new(room: hotel_room, start_date: start_date, end_date: end_date)
        hotel.reservations << reservation
        hotel_room.reservations << reservation
      end
      
      expect {
        hotel.reserve_room(start_date: start_date, end_date: end_date)
      }.must_raise ArgumentError
    end
    
    # tests regarging creation of a Reservation
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
  
  describe "#block" do
    let(:block_one) {
      hotel.block(number_of_rooms: 3, price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
    }
    let(:block_two) {
      hotel.block(number_of_rooms: 5, price_per_night: 175.00, start_date: "june 1 2019", end_date: "june 10 2019")
    }
    
    it "creates a Block instance" do
      expect(block_one).must_be_instance_of HotelBooking::Block
    end  
    
    it "assigns each Block instance an ID" do
      expect(block_one.id).must_equal 1
      expect(block_two.id).must_equal 2
    end
    
    it "adds each Block instance to the hotel list" do
      block_one
      block_two    
      expect(hotel.blocks.length).must_equal 2
    end
  end
  
  describe "#add_rooms_to_block" do
    let(:new_block) {
      HotelBooking::Block.new(id: 1, start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
    }
    
    it "can populate a Block's list of rooms" do
      hotel.blocks << new_block
      hotel.add_rooms_to_block(1)
      
      expect(new_block.rooms.length).must_equal 5
      new_block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
  end
  
  describe "#find_by_date" do
    let(:start_date) {
      "feb 3 2019"
    }
    let(:end_date) {
      "feb 6 2019"
    }
    
    it "will accept a single date" do
      reservation = HotelBooking::Reservation.new(room: room_two, start_date: start_date, end_date: end_date)
      hotel.reservations << reservation
      
      overlapping_reservations = hotel.find_by_date("feb 4 2019")
      expect(overlapping_reservations).must_include reservation
    end
    
    # test cases
    # 		3	4	5	6				= original range
    #     3	4	5	6				=> overlaps completely
    # 	    4	5					=> overlaps middle only
    #   2	3	4						=> overlaps beginning
    #		      5	6	7			=> overlaps end
    # 1	2	3							=> checkout day overlaps checkin day
    #		        6	7	8		=> checkin day overlaps checkout day
    
    it "should return: reservation that overlaps completely" do
      total_overlap = HotelBooking::Reservation.new(room: room_two, start_date: start_date, end_date: end_date)
      hotel.reservations << total_overlap
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).must_include total_overlap
    end
    
    it "should return: reservation that overlaps the input's middle" do
      middle_overlap = HotelBooking::Reservation.new(room: room_two, start_date: "feb 4 2019", end_date: "feb 5 2019")
      hotel.reservations << middle_overlap
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).must_include middle_overlap
    end
    
    it "should return: reservation that overlaps the input's first two days" do
      beginning_overlap = HotelBooking::Reservation.new(room: room_two, start_date: "feb 2 2019", end_date: "feb 4 2019")
      hotel.reservations << beginning_overlap
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).must_include beginning_overlap
    end
    
    it "should return: reservation that overlaps the input's last two days" do
      ending_overlap = HotelBooking::Reservation.new(room: room_two, start_date: "feb 5 2019", end_date: "feb 7 2019")
      hotel.reservations << ending_overlap
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).must_include ending_overlap
    end
    
    it "returns a collection of reservations" do
      beginning_overlap = HotelBooking::Reservation.new(room: room_two, start_date: "feb 2 2019", end_date: "feb 4 2019")
      ending_overlap = HotelBooking::Reservation.new(room: room_two, start_date: "feb 5 2019", end_date: "feb 7 2019")
      
      hotel.reservations << beginning_overlap
      hotel.reservations << ending_overlap
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).must_be_instance_of Array
      
      overlapping_reservations.each do |single_reservation|
        expect(single_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
    # should it include reservations that only overlap on the last day, checkout day?
    # The user story says they want to be able to "track reservations by date,
    # but doesn't why they want this functionality.
    # If you want to know how many people are in the hotel,
    # you'd want a reservation that begins on another reservation's end day to count as an overlap.
    # If you want to know how many ongoing reservations are in a day,
    # perhaps you'd want to exclude reservations that are ending.
    # If you want to know how many people are in the hotel, I think you wouldn't look at the number of reservations, as they don't yet count guests.
    # So I'm going to assume you want only ongoing reservations.
    # aka, how many nights have been reserved during this range?
    
    it "should not return: reservation that ends on the input's check-in day" do
      overlaps_checkin = HotelBooking::Reservation.new(room: room_two, start_date: "feb 1 2019", end_date: "feb 3 2019")
      hotel.reservations << overlaps_checkin
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).wont_include overlaps_checkin
    end
    
    it "should not return: reservation that begins on the input's check-out day" do
      overlaps_checkout = HotelBooking::Reservation.new(room: room_two, start_date: "feb 6 2019", end_date: "feb 8 2019")
      hotel.reservations << overlaps_checkout
      
      overlapping_reservations = hotel.find_by_date(start_date, end_date)
      expect(overlapping_reservations).wont_include overlaps_checkout
    end
    
  end
  
  describe "#find_available_rooms" do
    it "returns a collection of available rooms" do
      available_rooms = hotel.find_available_rooms(start_date: "jan 1 2019", end_date: "jan 5 2019")
      expect(available_rooms).must_be_instance_of Array
    end
    
    it "returns all rooms if no reservations have been made" do
      available_rooms = hotel.find_available_rooms(start_date: "aug 1 2019", end_date: "aug 5 2019")
      expect(available_rooms.length).must_equal 20
    end
    
    it "raise an exception if no rooms are available" do
      hotel.room_total.times do |room_num|
        room = hotel.find_by_room_number(room_num + 1)
        new_reservation = HotelBooking::Reservation.new(room: room, start_date: "feb 1 2019", end_date: "feb 5 2019")
        hotel.reservations << new_reservation
        room.reservations << new_reservation
      end
      
      expect {
        hotel.find_available_rooms(start_date: "feb 1 2019", end_date: "feb 5 2019")
      }.must_raise ArgumentError
    end
    
    it "returns all but one room if one room has been reserved" do
      room = hotel.find_by_room_number(2)
      new_reservation = HotelBooking::Reservation.new(room: room, start_date: "march 1 2019", end_date: "march 5 2019")
      hotel.reservations << new_reservation
      room.reservations << new_reservation
      
      available_rooms = hotel.find_available_rooms(start_date: "march 1 2019", end_date: "march 5 2019")
      
      expect(available_rooms.length).must_equal 19
      available_rooms.each do |available_room|
        expect(available_room.number).wont_equal 2
      end
    end
    
    it "returns all but two rooms if two rooms have been reserved" do
      room = hotel.find_by_room_number(2)
      new_reservation = HotelBooking::Reservation.new(room: room, start_date: "march 1 2019", end_date: "march 5 2019")
      hotel.reservations << new_reservation
      room.reservations << new_reservation
      
      other_room = hotel.find_by_room_number(12)
      second_reservation = HotelBooking::Reservation.new(room: other_room, start_date: "march 1 2019", end_date: "march 5 2019")
      hotel.reservations << second_reservation
      other_room.reservations << second_reservation
      
      available_rooms = hotel.find_available_rooms(start_date: "march 1 2019", end_date: "march 5 2019")
      
      expect(available_rooms.length).must_equal 18
      available_rooms.each do |available_room|
        expect(available_room.number).wont_equal 2
        expect(available_room.number).wont_equal 12
      end
    end
  end
  
end
