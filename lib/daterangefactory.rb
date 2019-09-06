module HotelBooking
  class DateRangeFactory
    
    def make_daterange(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
  end
end
