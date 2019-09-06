module HotelBooking
  class BlockFactory
    
    def make_block(id:, start_date: nil, end_date: nil, price_per_night:)
      return Block.new(id: id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
    end
    
  end
end