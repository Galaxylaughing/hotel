module HotelBooking
  class ReservationFactory
    
    def make_reservation(id:, start_date:, end_date:, price_per_night:)
      return Reservation.new(id: id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
    end
    
  end
end
