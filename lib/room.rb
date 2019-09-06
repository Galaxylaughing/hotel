module HotelBooking
  class Room
    
    attr_reader :number, :reservations
    
    def initialize(room_number)
      unless room_number.to_i > 0
        raise ArgumentError.new("Invalid room number; expected a positive Integer, received #{room_number}")
      end
      
      @number = room_number
      @reservations = []
    end
    
    def add_reservation_to_list(new_reservation)
      unless new_reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{new_reservation}")
      end
      
      unless new_reservation.room.number == number
        raise ArgumentError.new("Invalid reservation; expected a reservation for room #{number} but received a reservation for room #{new_reservation.room}")
      end
      
      reservations << new_reservation
    end
    
    def is_available?(date_range)
      available = true
      
      reservations.each do |single_reservation|
        if single_reservation.dates.overlaps?(date_range)
          available = false
        end
      end
      
      return available
    end
    
  end
end