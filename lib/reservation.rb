module HotelBooking
  class Reservation
    
    attr_reader :room, :dates, :price_per_night
    
    def initialize(room:, start_date:, end_date:, price_per_night: 200.00)
      unless room.class == Room
        raise ArgumentError.new("Excepted Room instance, given #{room}")
      end
      
      @room = room
      @price_per_night = price_per_night
      @dates = Reservation.make_dates(start_date: start_date, end_date: end_date)
    end
    
    def self.make_dates(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
    def total_price()
      total_price = price_per_night * dates.nights
      return total_price
    end
    
  end  
end
