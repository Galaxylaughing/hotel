module HotelBooking
  class ReservationFactory
    
    def make_reservation(room:, start_date:, end_date:, price_per_night: 200.00)
      return Reservation.new(room: room, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
    end
    
  end
end
