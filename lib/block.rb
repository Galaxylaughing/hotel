module HotelBooking
  class Block
    
    attr_reader :id, :dates, :price_per_night, :reservations, :room_total
    
    attr_accessor :daterange_factory, :room_factory, :rooms
    
    def initialize(id:, room_numbers:, start_date: nil, end_date: nil, price_per_night:, room_source: nil)
      @id = id
      @price_per_night = price_per_night
      @room_total = room_numbers.length
      
      @reservations = []
      @daterange_factory = DateRangeFactory.new()
      @room_factory = RoomFactory.new()
      
      if !(start_date.nil? && end_date.nil?)
        @dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      end
      
      @rooms = load_rooms(room_numbers: room_numbers, room_source: room_source)
    end
    
    def list_rooms()
      return rooms.map do |room|
        room.number
      end
    end
    
    def find_room(room_number)
      return rooms.find { |room| room.number == room_number }
    end
    
    def load_rooms(room_numbers:, room_source:)
      rooms_list = []
      room_numbers.each do |room_number|
        if room_source.nil?
          rooms_list << room_factory.make_room(room_number)
        else
          found_room = room_source.find_room(room_number)
          availability = found_room.is_available?(start_date: self.dates.start_date, end_date: self.dates.end_date)
          if !availability
            raise ArgumentError.new("Room #{room_number} is not available")
          end
          rooms_list << found_room
        end
      end
      return rooms_list
    end
    
    def reserve_room(reservation_id:, room_number: nil, start_date:, end_date:)
      if !(dates.nil?)
        first_date = Date.parse(start_date)
        last_date = Date.parse(end_date)
        
        unless first_date == dates.start_date && last_date == dates.end_date
          raise ArgumentError.new("Block reservations must be for the full duration of the block")
        end
      end
      
      available_rooms = all_available_rooms(start_date: start_date, end_date: end_date)
      
      if available_rooms.empty?
        raise ArgumentError.new("There are no available rooms at this time")
      end
      
      if room_number.nil?
        chosen_room = available_rooms.first
      else
        chosen_room = find_room(room_number)
      end
      
      chosen_room.make_reservation(reservation_id: reservation_id, start_date: start_date, end_date: end_date, price_per_night: price_per_night)
      
      return reservation_id
    end
    
    def all_available_rooms(start_date: nil, end_date: nil)
      
      if start_date.nil? || end_date.nil?
        start_date = self.dates.start_date
        end_date = self.dates.end_date
      end
      
      available_rooms = []
      rooms.each do |single_room|
        if single_room.is_available?(start_date: start_date, end_date: end_date)
          available_rooms << single_room
        end
      end
      
      return available_rooms
    end
    
    def find_reservations_by_date(date)
      reservation_ids = []
      rooms.each do |block_room|
        ids = block_room.find_reservations_by_date(date)
        if ids.length > 0
          # .concat adds each item in ids to reservation_ids
          reservation_ids.concat(ids)
        end
      end
      return reservation_ids
    end
    
    def find_price_of_reservation(reservation_id)
      rooms.each do |block_room|
        total = block_room.get_reservation_price(reservation_id)
        if !(total.nil?)
          return total
        end
      end
      raise ArgumentError.new("There is no reservation with the id #{reservation_id}")
    end
    
  end
end