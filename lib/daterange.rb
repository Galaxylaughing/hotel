module HotelBooking
  class DateRange
    
    attr_reader :start_date, :end_date
    
    def initialize(start_date, end_date)
      date_one = Date.parse(start_date)
      date_two = Date.parse(end_date)
      
      if DateRange.is_valid?(date_one, date_two)
        @start_date = date_one
        @end_date = date_two
      else
        raise ArgumentError.new("Invalid date range; got #{start_date}, #{end_date}")
      end
    end
    
    def self.is_valid?(date_one, date_two) 
      return ((date_two - date_one) > 0) ? true : false      
    end
    
  end
end
