module HotelBooking
  class Hotel
    
    attr_reader :room_total, :cost_per_night, :rooms, :reservations
    
    def initialize(number_of_rooms, cost_per_night)
      @room_total = number_of_rooms
      @cost_per_night = cost_per_night
      @rooms = load_rooms(number_of_rooms)
      @reservations = []
    end
    
    def load_rooms(number_of_rooms)
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << Room.new(room_number)
      end
      return rooms_list
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
    
    def make_reservation(start_date, end_date)
      available_rooms = self.find_available_rooms(start_date, end_date)
      chosen_room = available_rooms.first
      
      new_reservation = Reservation.new(room: chosen_room, start_date: start_date, end_date: end_date)
      
      chosen_room.add_reservation(new_reservation)
      self.add_reservation(new_reservation)
      
      return new_reservation
    end
    
    def find_by_date(start_date, end_date = nil)
      overlapping_reservations = []
      
      if end_date == nil
        date = Date.parse(start_date)
        
        reservations.each do |reservation|
          range = reservation.dates.start_date...reservation.dates.end_date
          if range.include?(date)
            overlapping_reservations << reservation
          end
        end
      else
        range = DateRange.new(start_date: start_date, end_date: end_date)
        
        reservations.each do |reservation|
          if range.overlaps?(reservation.dates)
            overlapping_reservations << reservation
          end
        end
      end
      
      return overlapping_reservations
    end
    
    def find_available_rooms(start_date, end_date)
      dates = DateRange.new(start_date: start_date, end_date: end_date)
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
