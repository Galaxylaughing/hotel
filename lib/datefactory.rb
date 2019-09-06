module HotelBooking
  class DateFactory
    
    def make_date(date)
      return Date.parse(date)
    end
    
  end
end