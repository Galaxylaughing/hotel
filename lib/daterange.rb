module HotelBooking
  class DateRange
    
    attr_reader :start_date, :end_date, :nights
    
    def initialize(start_date, end_date)
      date_one = Date.parse(start_date)
      date_two = Date.parse(end_date)
      
      if DateRange.is_valid?(date_one, date_two)
        @start_date = date_one
        @end_date = date_two
        @nights = DateRange.count_nights(date_one, date_two)
      else
        raise ArgumentError.new("Invalid date range; got #{start_date}, #{end_date}")
      end
    end
    
    def self.count_nights(start_date, end_date)
      return (end_date - start_date).to_i
    end
    
    def self.is_valid?(date_one, date_two) 
      return (self.count_nights(date_one, date_two) > 0) ? true : false      
    end
    
  end
end
