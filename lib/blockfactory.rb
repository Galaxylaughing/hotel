module HotelBooking
  class BlockFactory
    
    def make_block(id:, room_numbers:, start_date: nil, end_date: nil, price_per_night:, room_source: nil)
      return Block.new(id: id, room_numbers: room_numbers, start_date: start_date, end_date: end_date, price_per_night: price_per_night, room_source: room_source)
    end
    
  end
end