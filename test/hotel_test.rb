  require_relative 'test_helper'
  
  describe "Hotel" do
    let(:hotel) {
      HotelBooking::Hotel.new(room_count: 20, price_per_night: 200.00, max_rooms_per_block: 5)
    }
    let(:room_two) {
      HotelBooking::Room.new(2)
    }
    
    describe "initialize" do
      it "can create a Hotel Object" do
        expect(hotel).must_be_instance_of HotelBooking::Hotel
      end
      
      it "has a reservation total" do
        expect(hotel.reservation_total).must_equal 0
      end
      
      it "can update its reservation total" do
        hotel.reservation_total += 1
        expect(hotel.reservation_total).must_equal 1
      end
    end
    
    describe "#load_default_block" do
      let(:default_block) {
        hotel.load_default_block(hotel.room_total)
      }
      
      it "creates a collection of blocks" do
        expect(hotel.blocks).must_be_instance_of Array
      end
      
      it "creates one new block" do
        expect(hotel.blocks.length).must_equal 1
      end
      
      it "creates a block with the id of zero" do
        expect(hotel.blocks[0]).must_be_instance_of HotelBooking::Block
        expect(hotel.blocks[0].id).must_equal 0
      end
      
      # it "has a collection of rooms" do
      #   expect(hotel.blocks[0].rooms).must_be_instance_of Array
      #   hotel.blocks[0].rooms.each do |single_room|
      #     expect(single_room).must_be_instance_of HotelBooking::Room
      #   end
      # end
      
      # it "creates a block with the number of rooms the hotel has" do
      #   expect(hotel.blocks[0].rooms.length).must_equal hotel.room_total
      # end
    end
    
    describe "#find_block_by_id" do
      let(:new_block) {
        HotelBooking::Block.new(id: 5, room_numbers: Array(1..4), start_date: "feb 20 2019", end_date: "feb 28 2019", price_per_night: 175.00)
      }
      
      it "returns a Block instance" do
        hotel.blocks << new_block
        found_block = hotel.find_block_by_id(5)
        expect(found_block).must_be_instance_of HotelBooking::Block
      end
      
      it "raises an error for nonexistent block IDs" do
        expect {
          hotel.find_block_by_id(40)
        }.must_raise StandardError
      end
      
      it "raises an error for invalid block IDs" do
        expect {
          hotel.find_block_by_id("cookie")
        }.must_raise StandardError
      end
    end
    
    # describe "#all_reservations" do
    
    #   it "returns a collection of all reservations" do
    #     default_reservation = HotelBooking::Reservation.new(room: room_two, start_date: "dec 3 2019", end_date: "dec 8 2019")
    
    #     hotel.blocks.first.add_reservation_to_list(default_reservation)
    
    #     # block_reservation = HotelBooking::Reservation.new(room: room_two, start_date: "dec 3 2019", end_date: "dec 8 2019")
    
    #     # add new block to hotel list
    #     # block.add_reservation_to_list(block_reservation)
    
    #     result = hotel.all_reservations()
    #     expect(result).must_include default_reservation
    #     # expect(result).must_include block_reservation
    #   end
    
    # end
    
    describe "#find_reservation_by_date" do
      let(:start_date) {
        "feb 3 2019"
      }
      let(:end_date) {
        "feb 6 2019"
      }
      
      it "should return: date that occurs in the input's middle" do
        hotel.reserve_room(start_date: start_date, end_date: end_date)
        
        overlapping_reservations = hotel.find_reservations_by_date("feb 4 2019")
        expect(overlapping_reservations.length).must_equal 1
      end
      
      it "should return: date that matches the input's check-in day" do
        hotel.reserve_room(start_date: start_date, end_date: end_date)
        
        overlapping_reservations = hotel.find_reservations_by_date(start_date)
        expect(overlapping_reservations.length).must_equal 1
      end
      
      it "should NOT return: date that matches the input's check-out day" do
        hotel.reserve_room(start_date: start_date, end_date: end_date)
        
        overlapping_reservations = hotel.find_reservations_by_date(end_date)
        expect(overlapping_reservations.length).must_equal 0
      end
      
      it "should return: date that occurs in the input's middle for a given block" do
        hotel.create_block(room_numbers: [1, 4, 5, 8, 9], price_per_night: 150.00, start_date: start_date, end_date: end_date)
        
        hotel.reserve_room(block_id: 1, start_date: start_date, end_date: end_date)
        
        overlapping_reservations = hotel.find_reservations_by_date("feb 4 2019")
        expect(overlapping_reservations.length).must_equal 1
      end
      
    end
    
    describe "#create_block" do      
      
      it "adds each Block instance to the hotel list" do
        new_hotel = HotelBooking::Hotel.new(room_count: 20, price_per_night: 200.00, max_rooms_per_block: 5)
        
        new_hotel.create_block(room_numbers: Array(1..3), price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
        new_hotel.create_block(room_numbers: Array(1..5), price_per_night: 175.00, start_date: "june 1 2019", end_date: "june 10 2019")   
        
        expect(new_hotel.blocks.length).must_equal 3
      end
      
      it "raises an exception for blocks with too many rooms" do
        new_hotel = HotelBooking::Hotel.new(room_count: 20, price_per_night: 200.00, max_rooms_per_block: 5)
        
        expect {
          new_hotel.create_block(room_numbers: Array(1..6), price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
        }.must_raise ArgumentError
      end
      
      # ask hotel to create a block that includes a specific room that's already in another block, for the same date/s.
      it "can't create a block with a room that's in another block during that time" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        }.must_raise ArgumentError
      end
      
      it "can't create a block with a room that's in another block during the middle of that time" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 12 2019", end_date: "december 18 2019", price_per_night: 150.00)
        }.must_raise ArgumentError
      end
      
      it "can't create a block with a room that's in another block during the beginning of that time" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 8 2019", end_date: "december 12 2019", price_per_night: 150.00)
        }.must_raise ArgumentError
      end
      
      it "CAN create a block with a room that's in another block during some other time" do
        # previous block
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        # end block
        hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 1 2019", end_date: "december 8 2019", price_per_night: 150.00)
        # won't raise argument error
      end
      
      it "CAN create a block with a room that's in another block that begins on the day the new block ends" do
        # previous block
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        # new block
        hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 1 2019", end_date: "december 10 2019", price_per_night: 150.00)
        # won't raise argument error
      end
      
      it "CAN create a block with a room that's in another block that ends on the day the new block begins" do
        # previous block
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        # new block
        hotel.create_block(room_numbers: [1, 7, 8, 9], start_date: "december 20 2019", end_date: "december 28 2019", price_per_night: 150.00)
        # won't raise argument error
      end
      
    end
    
    describe "#list_rooms" do
      
      it "returns a list of room numbers" do
        new_hotel = HotelBooking::Hotel.new(room_count: 20, price_per_night: 200.00, max_rooms_per_block: 5)
        
        room_list = new_hotel.list_rooms()
        
        expect(room_list).must_be_instance_of Array
        expect(room_list.length).must_equal 20
        
        expect(room_list.eql?(Array(1..20))).must_equal true
      end
      
    end
    
    describe "#find_price_of_reservation" do
      
      it "can find the total price of a reservation" do
        reservation_number = hotel.reserve_room(start_date: "jan 4, 2019", end_date: "jan 8, 2019")
        
        total = hotel.find_price_of_reservation(reservation_number)
        
        expect(total).must_equal (4 * 200.00)
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
      
      it "returns all but one room if one room has been reserved" do
        hotel.reserve_room(start_date: "march 1 2019", end_date: "march 5 2019")
        
        available_rooms = hotel.find_available_rooms(start_date: "march 1 2019", end_date: "march 5 2019")
        
        expect(available_rooms.length).must_equal 19
      end
      
      it "returns all but two rooms if two rooms have been reserved" do
        hotel.reserve_room(start_date: "march 1 2019", end_date: "march 5 2019")
        
        hotel.reserve_room(start_date: "march 1 2019", end_date: "march 5 2019")
        
        available_rooms = hotel.find_available_rooms(start_date: "march 1 2019", end_date: "march 5 2019")
        
        expect(available_rooms.length).must_equal 18
      end
      
      it "returns all available rooms in a block" do
        block = hotel.create_block(room_numbers: Array(1..3), price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
        
        available_rooms = hotel.find_available_rooms(block_id: block.id)
        
        expect(available_rooms.length).must_equal 3
      end
      
      it "raises an exception if not given any arguments" do
        expect {
          hotel.find_available_rooms()
        }.must_raise ArgumentError
      end
      
    end
    
    describe "#reserve_room in default block" do
      
      it "updates the hotel's reservation total" do
        reservation_total = hotel.reservation_total
        hotel.reserve_room(start_date: "march 1 2019", end_date: "march 4 2019")
        expect(hotel.reservation_total).must_equal (reservation_total + 1)
      end
      
      it "can't reserve a room that's already in another block for the length of that block" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.reserve_room(room_number: 3, start_date: "december 10 2019", end_date: "december 20 2019")
        }.must_raise StandardError
      end
      
      it "can't reserve a room that's already in another block during that block" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.reserve_room(room_number: 3, start_date: "december 14 2019", end_date: "december 18 2019")
        }.must_raise StandardError
      end
      
      it "can't reserve a room that's already in another block for a date that overlaps that block" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        expect {
          hotel.reserve_room(room_number: 3, start_date: "december 19 2019", end_date: "december 25 2019")
        }.must_raise StandardError
      end
      
      it "CAN reserve a room for a duration that ends when a block begins" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        hotel.reserve_room(room_number: 3, start_date: "december 5 2019", end_date: "december 10 2019")
        # should not throw an error
      end
      
      it "CAN reserve a room for a duration that ends when a block ends" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        hotel.reserve_room(room_number: 3, start_date: "december 20 2019", end_date: "december 25 2019")
        # should not throw an error
      end
      
      it "CAN reserve a room that is not in a block" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        hotel.reserve_room(room_number: 8, start_date: "december 20 2019", end_date: "december 25 2019")
        # should not throw an error
      end
      
      it "CAN reserve a room that is in a block for different dates" do
        hotel.create_block(room_numbers: [1, 3, 5], start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
        
        hotel.reserve_room(room_number: 3, start_date: "december 1 2019", end_date: "december 8 2019")
        # should not throw an error
      end
      
    end
    
    describe "#reserve_room in non-default block" do
      
      it "updates the hotel's reservation total" do
        reservation_total = hotel.reservation_total
        
        hotel.create_block(room_numbers: Array(1..4), price_per_night: 150.00, start_date: "march 1 2019", end_date: "march 4 2019")
        
        hotel.reserve_room(block_id: 1, start_date: "march 1 2019", end_date: "march 4 2019")
        
        expect(hotel.reservation_total).must_equal (reservation_total + 1)
      end
      
      it "allows you to reserve from a specific block" do
        block = hotel.create_block(room_numbers: Array(3..6), price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
        
        hotel.reserve_room(block_id: block.id, start_date: "march 5 2019", end_date: "march 10 2019")
        
        available_rooms = block.all_available_rooms()
        
        available_rooms.each do |available_room|
          expect(available_room.number).wont_equal 3
        end
      end
      
      it "allows you to reserve a specific room" do
        block = hotel.create_block(room_numbers: Array(1..3), price_per_night: 150.00, start_date: "march 5 2019", end_date: "march 10 2019")
        
        hotel.reserve_room(block_id: block.id, room_number: 2, start_date: "march 5 2019", end_date: "march 10 2019")
        
        available_rooms = block.all_available_rooms()
        
        available_rooms.each do |available_room|
          expect(available_room.number).wont_equal 2
        end
      end
      
    end
    
  end
  