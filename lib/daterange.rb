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
    
    def self.is_valid?(date_one, date_two) 
      return (self.count_nights(date_one, date_two) > 0) ? true : false      
    end
    
    def self.count_nights(start_date, end_date)
      return (end_date - start_date).to_i
    end
    
    def overlaps?(other_range)
      range_one = self.start_date...self.end_date
      range_two = other_range.start_date...other_range.end_date
      
      overlap = range_one.cover?(range_two.first) || range_two.cover?(range_one.first)
      
      return overlap ? true : false
    end
    
  end
end
