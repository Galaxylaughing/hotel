module HotelBooking
  class Hotel
    
    attr_reader :room_total, :price_per_night, :rooms, :reservations, :max_rooms_per_block, :blocks
    
    attr_accessor :room_factory
    
    def initialize(number_of_rooms:, price_per_night:, max_rooms_per_block: nil)
      @room_total = number_of_rooms
      @price_per_night = price_per_night
      @reservations = []
      @blocks = []
      @max_rooms_per_block = max_rooms_per_block
      
      @room_factory = RoomFactory.new()
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
    
    # instantiate a Reservation instance
    def self.make_reservation(room:, start_date:, end_date:)
      return Reservation.new(room: room, start_date: start_date, end_date: end_date)
    end
    
    # instantiate a DateRange instance
    def self.make_daterange(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
    # instantiate a Date instance
    def self.make_date(date)
      return Date.parse(date)
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
    def find_block_by_id(block_id:)
      blocks.each do |hotel_block|
        if hotel_block.id == block_id
          return hotel_block
        end
      end
      raise ArgumentError.new("No block found with the number #{block_id}")
    end
    
    # add a Reservation instance by a hotel's @reservations list
    def add_reservation(new_reservation)
      unless new_reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{new_reservation}")
      end
      
      reservations << new_reservation
    end
    
    # add a Block instance by a hotel's @blocks list
    def add_block(new_block)
      unless new_block.class == Block
        raise ArgumentError.new("Invalid block; expected Block instance, received #{new_block}")
      end
      
      blocks << new_block
    end
    
    # reserve a room in a hotel
    def reserve(start_date:, end_date:)
      available_rooms = self.find_available_rooms(start_date: start_date, end_date: end_date)
      chosen_room = available_rooms.first
      
      new_reservation = Hotel.make_reservation(room: chosen_room, start_date: start_date, end_date: end_date)
      
      chosen_room.add_reservation(new_reservation)
      self.add_reservation(new_reservation)
      
      return new_reservation
    end
    
    def block(number_of_rooms:, price_per_night:, start_date:, end_date:)
      block_id = (blocks.length + 1)
      
      new_block = Block.new(id: block_id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
      
      add_block(new_block)
      
      return new_block
    end
    
    # add Room instances to a block
    def add_rooms_to_block(block_id:)
      block = find_block_by_id(block_id: block_id)
      
      available_rooms = find_available_rooms(start_date: block.dates.start_date, end_date: block.dates.end_date)
      
      until block.rooms.length == max_rooms_per_block
        block.add_room(available_rooms.pop)
      end
      
    end
    
    # find a Reservation instance by date
    def find_by_date(start_date, end_date = nil)
      overlapping_reservations = []
      
      if end_date == nil
        date = Hotel.make_date(start_date)
        
        reservations.each do |reservation|
          range = reservation.dates.start_date...reservation.dates.end_date
          if range.include?(date)
            overlapping_reservations << reservation
          end
        end
      else
        range = Hotel.make_daterange(start_date: start_date, end_date: end_date)
        
        reservations.each do |reservation|
          if range.overlaps?(reservation.dates)
            overlapping_reservations << reservation
          end
        end
      end
      
      return overlapping_reservations
    end
    
    # find all available Room instances from a hotel's room list
    def find_available_rooms(start_date:, end_date:)
      dates = Hotel.make_daterange(start_date: start_date, end_date: end_date)
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
