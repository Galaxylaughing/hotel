require_relative 'test_helper'

describe "Block" do
  
  describe "initialize, for a room block" do
    let(:block) {
      HotelBooking::Block.new(id: 1, number_of_rooms: 5, start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
    }
    
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
      block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    it "has a list of Reservations" do
      expect(block.reservations).must_be_instance_of Array
      block.reservations.each do |block_reservation|
        expect(block_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
  end
  
  describe "initialize, for a hotel's default block" do
    let(:block) {
      HotelBooking::Block.new(number_of_rooms: 20, price_per_night: 200.00)
    }
    
    it "can create a Block instance" do
      expect(block).must_be_instance_of HotelBooking::Block
    end
    
    it "has an id" do
      expect(block.id).must_be_instance_of Integer
      expect(block.id).must_equal 0
    end
    
    it "has a nil start date and end dates" do
      expect(block.dates).must_be_nil
    end
    
    it "has a price per night" do
      expect(block.price_per_night).must_be_instance_of Float
      expect(block.price_per_night).must_equal 200.00
    end
    
    it "has a list of Rooms" do
      expect(block.rooms).must_be_instance_of Array
      block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    it "has a list of Reservations" do
      expect(block.reservations).must_be_instance_of Array
      block.reservations.each do |block_reservation|
        expect(block_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
  end
  
  describe "#load_rooms" do
    let(:block) {
      HotelBooking::Block.new(number_of_rooms: 20, price_per_night: 200.00)
    }
    
    it "creates an collection of Rooms" do
      new_rooms = block.load_rooms(20)
      expect(new_rooms).must_be_instance_of Array
      new_rooms.each do |single_room|
        expect(single_room).must_be_instance_of HotelBooking::Room
      end
    end
    
    # for loop automatically raises an ArgumentError "bad value for range"
    it "raises an exception if not given a valid integer" do
      expect {
        block.load_rooms("20")
      }.must_raise ArgumentError
    end
  end
  
  describe "#contains_room?" do
    let(:default_block) {
      HotelBooking::Block.new(number_of_rooms: 20, price_per_night: 200.00)
    }
    let(:special_block) {
      HotelBooking::Block.new(number_of_rooms: 3, price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
    }
    
    it "returns true if the default block contains the room" do
      expect(default_block.contains_room?(18)).must_equal true
    end
    
    it "returns false if the default block does NOT contain the room" do
      expect(default_block.contains_room?("cookie")).must_equal false
    end
    
    # there should not be any reservations yet for any rooms
    # so room 1 should be available to be assigned to the new block
    it "returns true if a special block contains the room" do
      expect(special_block.contains_room?(1)).must_equal true
    end
    
    it "returns false if a special block does NOT contain the room" do
      expect(special_block.contains_room?("cookie")).must_equal false
    end
    
  end
  
  describe "#add_reservation_to_list" do
    let(:block) {
      HotelBooking::Block.new(number_of_rooms: 20, price_per_night: 200.00)
    }
    let(:room) {
      HotelBooking::Room.new(1)
    }
    let(:new_reservation) {
      HotelBooking::Reservation.new(room: room, start_date: "dec 1 2019", end_date: "dec 3 2019")
    }
    
    it "adds a reservation instance to the list" do
      block.add_reservation_to_list(new_reservation)
      expect(block.reservations).must_include new_reservation
    end
    
    it "raises an exception for an argument that isn't a Reservation Object" do
      new_reservation = "august 10th"
      expect {
        block.add_reservation_to_list(new_reservation)
      }.must_raise ArgumentError
    end
  end
  
end
