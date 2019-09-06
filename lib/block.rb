module HotelBooking
  class Block
    
    attr_reader :id, :dates, :price_per_night, :rooms
    
    attr_accessor :daterange_factory
    
    def initialize(id: 0, start_date: nil, end_date: nil, price_per_night:)
      @id = id
      @price_per_night = price_per_night
      
      @rooms = []
      @daterange_factory = DateRangeFactory.new()
      
      if !(start_date.nil? && end_date.nil?)
        @dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      end
    end
    
  end
end