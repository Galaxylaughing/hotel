module HotelBooking
  class Hotel
    
    attr_reader :room_total, :price_per_night, :reservations, :max_rooms_per_block, :blocks
    
    attr_accessor :room_factory, :reservation_factory, :date_factory, :block_factory, :daterange_factory
    
    def initialize(number_of_rooms:, price_per_night:, max_rooms_per_block: nil)
      @room_total = number_of_rooms
      @price_per_night = price_per_night
      @max_rooms_per_block = max_rooms_per_block
      
      @reservations = []
      
      @room_factory = RoomFactory.new()
      @reservation_factory = ReservationFactory.new()
      @daterange_factory = DateRangeFactory.new()
      @date_factory = DateFactory.new()
      @block_factory = BlockFactory.new()
      
      @blocks = load_default_block(number_of_rooms)
    end
    
    def load_default_block(number_of_rooms)
      blocks = []
      blocks << block_factory.make_block(id: 0, number_of_rooms: number_of_rooms, price_per_night: price_per_night)
    end
    
    def find_by_room_number(room_number)
      blocks[0].rooms.each do |hotel_room|
        if hotel_room.number == room_number
          return hotel_room
        end
      end
      raise ArgumentError.new("No room found with the number #{room_number}")
    end
    
    def find_block_by_id(block_id)
      blocks.each do |hotel_block|
        if hotel_block.id == block_id
          return hotel_block
        end
      end
      raise ArgumentError.new("No block found with the number #{block_id}")
    end
    
    def find_reservation_by_date(start_date, end_date = nil)
      overlapping_reservations = []
      
      range = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      reservations.each do |reservation|
        if range.overlaps?(reservation.dates)
          overlapping_reservations << reservation
        end
      end
      
      return overlapping_reservations
    end
    
    def add_reservation_to_list(reservation)
      unless reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{reservation}")
      end
      
      reservations << reservation
    end
    
    def create_block(number_of_rooms:, price_per_night:, start_date:, end_date:)
      block_id = blocks.length
      
      new_block = block_factory.make_block(id: block_id, number_of_rooms: number_of_rooms, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
      
      add_rooms_to_block(new_block)
      
      blocks << new_block
      
      return new_block
    end
    
    def reserve_room(block_id: 0, start_date:, end_date:)
      available_rooms = find_available_rooms(start_date: start_date, end_date: end_date)
      chosen_room = available_rooms.first
      
      new_reservation = reservation_factory.make_reservation(room: chosen_room, start_date: start_date, end_date: end_date)
      
      chosen_room.reservations << new_reservation
      reservations << new_reservation
      
      return new_reservation
    end
    
    def add_rooms_to_block(block)
      available_rooms = find_available_rooms(start_date: block.dates.start_date, end_date: block.dates.end_date)
      
      index = 0
      until block.rooms.length == block.room_total || block.rooms.length == block.room_total
        block.rooms << available_rooms[index]
        index += 1
      end
    end
    
    def find_available_rooms(start_date:, end_date:)
      dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      available_rooms = []
      
      blocks[0].rooms.each do |hotel_room|
        
        blocks.each do |hotel_block|
          if !(hotel_block.contains_room?(hotel_room)) && hotel_room.is_available?(dates)
            available_rooms << hotel_room
          end
        end
        
        # if hotel_room.is_available?(dates)
        #   available_rooms << hotel_room
        # end
        
      end
      
      if available_rooms.length == 0
        raise ArgumentError.new("There are no available rooms for these dates")
      end
      
      return available_rooms
    end
    
  end
end
