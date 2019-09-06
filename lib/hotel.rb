module HotelBooking
  class Hotel
    
    attr_reader :room_total, :price_per_night, :rooms, :reservations, :max_rooms_per_block, :blocks
    
    attr_accessor :room_factory, :reservation_factory, :daterange_factory, :date_factory, :block_factory
    
    def initialize(number_of_rooms:, price_per_night:, max_rooms_per_block: nil)
      @room_total = number_of_rooms
      @price_per_night = price_per_night
      @max_rooms_per_block = max_rooms_per_block
      
      @reservations = []
      @blocks = []
      
      @room_factory = RoomFactory.new()
      @reservation_factory = ReservationFactory.new()
      @daterange_factory = DateRangeFactory.new()
      @date_factory = DateFactory.new()
      @block_factory = BlockFactory.new()
      
      @rooms = load_rooms(number_of_rooms)
    end
    
    # populate a hotel's @rooms list
    def load_rooms(number_of_rooms)
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << room_factory.make_room(room_number)
      end
      return rooms_list
    end
    
    # give a hotel with its default block
    def load_default_block()
      blocks << block_factory.make_block(id: 0, price_per_night: price_per_night)
    end
    
    # find a Room instance by its number
    def find_by_room_number(room_number)
      rooms.each do |hotel_room|
        if hotel_room.number == room_number
          return hotel_room
        end
      end
      raise ArgumentError.new("No room found with the number #{room_number}")
    end
    
    # find a Block instance by its ID
    def find_block_by_id(block_id)
      blocks.each do |hotel_block|
        if hotel_block.id == block_id
          return hotel_block
        end
      end
      raise ArgumentError.new("No block found with the number #{block_id}")
    end
    
    # reserve a room in a hotel
    def reserve_room(start_date:, end_date:)
      available_rooms = self.find_available_rooms(start_date: start_date, end_date: end_date)
      chosen_room = available_rooms.first
      
      new_reservation = reservation_factory.make_reservation(room: chosen_room, start_date: start_date, end_date: end_date)
      
      chosen_room.reservations << new_reservation
      reservations << new_reservation
      
      return new_reservation
    end
    
    def block(number_of_rooms:, price_per_night:, start_date:, end_date:)
      block_id = (blocks.length + 1)
      
      new_block = Block.new(id: block_id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
      
      blocks << new_block
      
      return new_block
    end
    
    # add Room instances to a block
    def add_rooms_to_block(block_id)
      block = find_block_by_id(block_id)
      
      available_rooms = find_available_rooms(start_date: block.dates.start_date, end_date: block.dates.end_date)
      
      until block.rooms.length == max_rooms_per_block
        block.rooms << available_rooms.pop
      end
      
    end
    
    # find a Reservation instance by date
    def find_by_date(start_date, end_date = nil)
      overlapping_reservations = []
      
      range = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      reservations.each do |reservation|
        if range.overlaps?(reservation.dates)
          overlapping_reservations << reservation
        end
      end
      
      return overlapping_reservations
    end
    
    # find all available Room instances from a hotel's room list
    def find_available_rooms(start_date:, end_date:)
      dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      available_rooms = []
      
      rooms.each do |hotel_room|
        if hotel_room.is_available?(dates)
          available_rooms << hotel_room
        end
      end
      
      if available_rooms.length == 0
        raise ArgumentError.new("There are no available rooms for these dates")
      end
      
      return available_rooms
    end
    
  end
end
