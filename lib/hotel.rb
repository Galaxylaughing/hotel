module HotelBooking
  class Hotel
    
    attr_reader :room_total, :price_per_night, :rooms, :reservations
    
    def initialize(number_of_rooms:, price_per_night:)
      @room_total = number_of_rooms
      @price_per_night = price_per_night
      @rooms = load_rooms(number_of_rooms)
      @reservations = []
    end
    
    def load_rooms(number_of_rooms)
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << Hotel.make_room(room_number)
      end
      return rooms_list
    end
    
    def self.make_room(room_number)
      return Room.new(room_number)
    end
    
    def self.make_reservation(room:, start_date:, end_date:)
      return Reservation.new(room: room, start_date: start_date, end_date: end_date)
    end
    
    def self.make_daterange(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
    def self.make_date(date)
      return Date.parse(date)
    end
    
    def find_by_room_number(room_number)
      rooms.each do |hotel_room|
        if hotel_room.number == room_number
          return hotel_room
        end
      end
      raise ArgumentError.new("No room found with the number #{room_number}")
    end
    
    def add_reservation(new_reservation)
      unless new_reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{new_reservation}")
      end
      
      reservations << new_reservation
    end
    
    def reserve(start_date:, end_date:)
      available_rooms = self.find_available_rooms(start_date: start_date, end_date: end_date)
      chosen_room = available_rooms.first
      
      new_reservation = Hotel.make_reservation(room: chosen_room, start_date: start_date, end_date: end_date)
      
      chosen_room.add_reservation(new_reservation)
      self.add_reservation(new_reservation)
      
      return new_reservation
    end
    
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
