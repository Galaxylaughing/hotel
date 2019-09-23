module HotelBooking
  class Room
    
    attr_reader :number, :reservations
    
    attr_accessor :reservation_factory
    
    def initialize(room_number)
      unless room_number.to_i > 0
        raise ArgumentError.new("Invalid room number; expected a positive Integer, received #{room_number}")
      end
      
      @reservation_factory = ReservationFactory.new()
      
      @number = room_number
      @reservations = []
    end
    
    def add_reservation_to_list(new_reservation)
      unless new_reservation.class == Reservation
        raise AlreadyReservedError.new("Invalid reservation; expected Reservation instance, received #{new_reservation}")
      end
      
      reservations << new_reservation
    end
    
    def is_available?(start_date:, end_date:)
      dates = DateRange.new(start_date: start_date, end_date: end_date)
      available = true
      reservations.each do |single_reservation|
        if single_reservation.dates.overlaps?(dates)
          available = false
        end
      end
      return available
    end
    
    def make_reservation(reservation_id:, start_date:, end_date:, price_per_night:)
      if !(is_available?(start_date: start_date, end_date: end_date))
        raise AlreadyReservedError.new("This room already reserved during the provided time frame")
      end
      
      new_reservation = reservation_factory.make_reservation(id: reservation_id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
      
      add_reservation_to_list(new_reservation)
      
      return new_reservation
    end
    
    def find_reservations_by_date(date)
      reservation_ids = []
      reservations.each do |room_reservation|
        if room_reservation.includes_date(date)
          reservation_ids << room_reservation.id
        end
      end
      return reservation_ids
    end
    
    def get_reservation_price(reservation_id)
      total_price = nil
      reservations.each do |room_reservation|
        if room_reservation.id == reservation_id
          total_price = room_reservation.get_total_price()
          break
        end
      end
      return total_price
    end
    
  end
end