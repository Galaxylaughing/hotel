module HotelBooking
  class DateRange
    
    attr_reader :nights, :range
    
    def initialize(start_date:, end_date: nil)
      date_one = DateRange.make_date(start_date)
      
      if end_date.nil?
        date_two = date_one + 1
      else
        date_two = DateRange.make_date(end_date)
      end
      
      if DateRange.is_valid?(start_date: date_one, end_date: date_two)
        # exclude the last day, which is check-out day.
        @range = Range.new(date_one, date_two, exclude_end=true)
        @nights = DateRange.count_nights(start_date: date_one, end_date: date_two)
      else
        raise ArgumentError.new("Invalid date range; got #{start_date}, #{end_date}")
      end
    end
    
    def start_date()
      return range.begin
    end
    
    def end_date()
      return range.end
    end
    
    def self.make_date(date)
      unless date.class == Date
        date = Date.parse(date)
      end
      return date
    end
    
    def self.is_valid?(start_date:, end_date:) 
      return (self.count_nights(start_date: start_date, end_date: end_date) > 0) ? true : false      
    end
    
    def self.count_nights(start_date:, end_date:)
      return (end_date - start_date).to_i
    end
    
    def includes?(date)
      date = DateRange.new(start_date: date)
      return self.overlaps?(date)
    end
    
    def overlaps?(other_range)
      range_two = other_range.start_date...other_range.end_date
      
      overlap = range.cover?(range_two.first) || range_two.cover?(range.first)
      
      return overlap ? true : false
    end
    
  end
end
