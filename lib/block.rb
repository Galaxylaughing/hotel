module HotelBooking
  class Block
    
    attr_reader :id, :dates, :price_per_night
    
    def initialize(id:, start_date:, end_date:, price_per_night:)
      @id = id
      @dates = Block.make_daterange(start_date: start_date, end_date: end_date)
      @price_per_night = price_per_night
    end
    
    # same as Hotel
    def self.make_daterange(start_date:, end_date:)
      return DateRange.new(start_date: start_date, end_date: end_date)
    end
    
  end
end