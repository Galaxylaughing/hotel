module HotelBooking
  class Hotel
    
    attr_reader :room_total, :price_per_night, :max_rooms_per_block, :blocks
    
    attr_accessor :block_factory, :daterange_factory, :reservation_total
    
    def initialize(number_of_rooms:, price_per_night:, max_rooms_per_block: nil)
      @room_total = number_of_rooms
      @price_per_night = price_per_night
      @max_rooms_per_block = max_rooms_per_block
      
      @daterange_factory = DateRangeFactory.new()
      @block_factory = BlockFactory.new()
      
      @reservation_total = 0
      
      @blocks = []
      @blocks << load_default_block(Array(1..number_of_rooms))
    end
    
    def load_default_block(room_numbers)
      return block_factory.make_block(id: 0, room_numbers: room_numbers, price_per_night: price_per_night)
    end
    
    def find_block_by_id(block_id)
      blocks.each do |hotel_block|
        if hotel_block.id == block_id
          return hotel_block
        end
      end
      raise ArgumentError.new("No block found with the number #{block_id}")
    end
    
    def find_reservations_by_date(date) 
      default_block = get_default_block()
      overlapping_reservations = default_block.find_reservations_by_date(date)
      
      return overlapping_reservations
    end
    
    def get_default_block()
      return blocks[0]
    end
    
    def create_block(room_numbers:, price_per_night:, start_date:, end_date:)
      if room_numbers.length > max_rooms_per_block
        raise ArgumentError.new("Expected a maximum of #{max_rooms_per_block} rooms, received #{room_numbers.length} rooms")
      end
      
      dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      blocks.each do |hotel_block|
        next if (hotel_block.id == get_default_block().id)
        if hotel_block.dates.overlaps?(dates)
          room_list = hotel_block.list_rooms()
          room_numbers.each do |room_number|
            if room_list.include?(room_number)
              raise ArgumentError.new("Block #{hotel_block.id} already contains room #{room_number} during this time")
            end
          end
        end
      end
      
      block_id = blocks.length
      
      new_block = block_factory.make_block(id: block_id, room_numbers: room_numbers, start_date: start_date, end_date: end_date, price_per_night: price_per_night, room_source: get_default_block)
      
      blocks << new_block
      
      return new_block
    end
    
    def list_rooms()
      source = get_default_block()
      return source.list_rooms()
    end
    
    def reserve_room(block_id: nil, room_number: nil, start_date:, end_date:)
      if block_id.nil?
        block = get_default_block()
      else
        block = find_block_by_id(block_id)
      end
      
      self.reservation_total += 1
      reservation_number = reservation_total
      
      dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      
      blocks.each do |hotel_block|
        if (block_id.nil? || block_id != hotel_block.id) && (hotel_block.id != get_default_block().id)
          # does the block contain that room?
          # does the block exist over these dates?
          if hotel_block.find_room(room_number) && dates.overlaps?(hotel_block.dates)
            raise ArgumentError.new("Room #{room_number} is in block #{hotel_block.id} during these dates")
          end
        end
      end
      
      block.reserve_room(reservation_id: reservation_number, room_number: room_number, start_date: start_date, end_date: end_date)
      
      return reservation_number
    end
    
    def find_available_rooms(block_id: nil, start_date: nil, end_date: nil)
      if block_id
        block = find_block_by_id(block_id)
        available_rooms = block.all_available_rooms()
      elsif start_date && end_date
        available_rooms = get_default_block().all_available_rooms(start_date: start_date, end_date: end_date)
      else
        raise ArgumentError.new("Either a block id or a date range must be provided")
      end
      
      return available_rooms
    end
    
    def find_price_of_reservation(reservation_id)
      default_block = get_default_block()
      return default_block.find_price_of_reservation(reservation_id)
    end
    
  end
end
