require_relative 'test_helper'

describe "Block" do
  let(:default_block) {
    HotelBooking::Block.new(id: 0, room_numbers: Array(1..20), price_per_night: 200.00)
  }
  let(:block) {
    HotelBooking::Block.new(id: 1, room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00, room_source: default_block)
  }
  
  describe "initialize without a room source" do    
    it "can create a Block instance" do
      expect(default_block).must_be_instance_of HotelBooking::Block
    end
    
    it "has an id" do
      expect(default_block.id).must_be_instance_of Integer
      expect(default_block.id).must_equal 0
    end
    
    it "has a nil start date and end dates" do
      expect(default_block.dates).must_be_nil
    end
    
    it "has a price per night" do
      expect(default_block.price_per_night).must_be_instance_of Float
      expect(default_block.price_per_night).must_equal 200.00
    end
    
    it "has a list of Rooms" do
      expect(default_block.rooms).must_be_instance_of Array
      expect(default_block.rooms.length).must_equal 20
      default_block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    # it "has a list of Reservations" do
    #   expect(block.reservations).must_be_instance_of Array
    #   block.reservations.each do |block_reservation|
    #     expect(block_reservation).must_be_instance_of HotelBooking::Reservation
    #   end
    # end
  end
  
  describe "initialize with a room source" do    
    it "can create a Block instance" do
      expect(block).must_be_instance_of HotelBooking::Block
    end
    
    it "has an id" do
      expect(block.id).must_be_instance_of Integer
      expect(block.id).must_equal 1
    end
    
    it "has a DateRangeFactory" do
      expect(block.daterange_factory).must_be_instance_of HotelBooking::DateRangeFactory
    end
    
    it "has a DateRange" do
      expect(block.dates).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can read its start date" do
      expect(block.dates.start_date.to_s).must_equal "2019-12-10"
    end
    
    it "can read its end date" do
      expect(block.dates.end_date.to_s).must_equal "2019-12-20"
    end
    
    it "has a price per night" do
      expect(block.price_per_night).must_be_instance_of Float
      expect(block.price_per_night).must_equal 150.00
    end
    
    it "has a list of Rooms" do
      expect(block.rooms).must_be_instance_of Array
      expect(block.rooms.length).must_equal 3
      block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
        expect(block_room).must_equal (default_block.find_room(block_room.number))
      end
    end
    
    it "raises an exception if one of the rooms is reserved" do
      block.reserve_room(reservation_id: 1, start_date: "december 10 2019", end_date: "december 20 2019")
      
      expect {
        HotelBooking::Block.new(id: 2, room_numbers: [1, 5, 8, 7], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00, room_source: default_block)
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#list_rooms" do
    
    it "returns a sequential list of room numbers" do
      room_list = default_block.list_rooms()
      
      expect(room_list).must_be_instance_of Array
      expect(room_list.length).must_equal 20
      
      expect(room_list.eql?(Array(1..20))).must_equal true
    end
    
    it "returns a nonsequential list of room numbers" do
      room_array = [1, 3, 5]
      
      new_block = HotelBooking::Block.new(id: 1, room_numbers: room_array, start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00, room_source: default_block)
      
      room_list = new_block.list_rooms()
      
      expect(room_list).must_be_instance_of Array
      expect(room_list.length).must_equal 3
      
      expect(room_list.eql?(room_array)).must_equal true
    end
    
  end
  
  describe "#reserve_room" do
    it "creates a reservation for the default block" do
      default_block.reserve_room(reservation_id: 1, start_date: "march 1 2019", end_date: "march 4 2019")
      # should not raise an exception
    end
    
    it "creates a reservation for a non-default block" do
      block.reserve_room(reservation_id: 1, start_date: "december 10 2019", end_date: "december 20 2019")
      # should not raise an exception
    end
    
    it "creates a reservation for a specific room" do
      # block: reserve room three
      block.reserve_room(reservation_id: 1, room_number: 3, start_date: block.dates.start_date.to_s, end_date: block.dates.end_date.to_s)
      # block: give me your available rooms
      available_rooms = block.all_available_rooms()
      # room three should not be one of them
      available_rooms.each do |available_room|
        expect(available_room.number).wont_equal 3
      end
    end
    
    it "raises an exception for reservations outside the block's duration" do
      expect {
        block.reserve_room(reservation_id: 1, start_date: "march 1 2019", end_date: "march 4 2019")
      }.must_raise ArgumentError
    end
    
    it "raises an exception for reservations within but not equal to the block's duration" do
      expect {
        block.reserve_room(reservation_id: 1, start_date: "december 10 2019", end_date: "december 15 2019")
      }.must_raise ArgumentError
    end
    
    it "raises an exception if all of the rooms are unavailable" do
      3.times do |index|
        block.reserve_room(reservation_id: index, start_date: "december 10 2019", end_date: "december 20 2019")
      end
      
      expect {
        block.reserve_room(reservation_id: 2, start_date: "december 10 2019", end_date: "december 20 2019")
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#all_available_rooms" do
    # let(:hotel) {
    #   HotelBooking::Hotel.new(number_of_rooms: 20, price_per_night: 200.00, max_rooms_per_block: 5)
    # }
    # let(:block) {
    #   hotel.create_block(number_of_rooms: 5, price_per_night: 178.00, start_date: "may 1 2019", end_date: "may 4 2019")
    # }
    # let(:result) {
    #   block.all_available_rooms()
    # }
    
    it "returns a collection of available rooms within the special block" do
      result = block.all_available_rooms()
      expect(result).must_be_instance_of Array
      expect(result.length).must_equal 3
    end
    
    # it "returns all rooms if no reservations have been made" do
    #   result = block.all_available_rooms()
    #   expect(result.length).must_equal 3
    # end
    
    it "returns a collection of available rooms within the default block" do
      # result = default_block.all_available_rooms()
      result = default_block.all_available_rooms(start_date: "aug 5 2019", end_date: "aug 9 2019")
      expect(result).must_be_instance_of Array
      expect(result.length).must_equal default_block.rooms.length
    end
    
    # it "can take a date range" do
    #   result = default_block.all_available_rooms(start_date: "aug 5 2019", end_date: "aug 9 2019")
    #   expect(result).must_be_instance_of Array
    #   expect(result.length).must_equal default_block.rooms.length
    # end
    
    # it "returns zero if all rooms have been reserved" do
    #   block.rooms.each do |block_room|
    #     # make a reservation for that room
    #   end
    
    # end
    
  end
  
  describe "#find_reservation_by_date" do
    let(:start_date) {
      "feb 3 2019"
    }
    let(:end_date) {
      "feb 6 2019"
    }
    
    it "should return: date that occurs in the input's middle" do
      default_block.reserve_room(reservation_id: 1, start_date: start_date, end_date: end_date)
      
      overlapping_reservations = default_block.find_reservations_by_date("feb 4 2019")
      expect(overlapping_reservations.length).must_equal 1
    end
    
    it "should return: date that matches the input's check-in day" do
      default_block.reserve_room(reservation_id: 1, start_date: start_date, end_date: end_date)
      
      overlapping_reservations = default_block.find_reservations_by_date(start_date)
      expect(overlapping_reservations.length).must_equal 1
    end
    
    it "should NOT return: date that matches the input's check-out day" do
      default_block.reserve_room(reservation_id: 1, start_date: start_date, end_date: end_date)
      
      overlapping_reservations = default_block.find_reservations_by_date(end_date)
      expect(overlapping_reservations.length).must_equal 0
    end
    
  end
  
  describe "#find_price_of_reservation" do
    
    it "can find the total price of a reservation" do
      reservation_number = default_block.reserve_room(reservation_id: 1, start_date: "jan 4, 2019", end_date: "jan 8, 2019")
      
      total = default_block.find_price_of_reservation(reservation_number)
      
      expect(total).must_equal (4 * 200.00)
    end
    
    it "raises an exception for a nonexistent reservation id" do
      expect {
        default_block.find_price_of_reservation(20)
      }.must_raise ArgumentError
    end
    
  end
  
end
