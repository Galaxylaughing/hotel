module HotelBooking
  class Reservation
    
    attr_reader :dates, :price_per_night, :id
    
    def initialize(id:, start_date:, end_date:, price_per_night:)
      @id = id
      @price_per_night = price_per_night
      @dates = Reservation.make_dates(start_date: start_date, end_date: end_date)
    end
    
    def self.make_dates(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
    def get_total_price()
      total_price = price_per_night * dates.nights
      return total_price
    end
    
    def includes_date(date)
      return dates.includes?(date)
    end
    
  end  
end
