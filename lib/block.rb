module HotelBooking
  class Block
    
    attr_reader :id, :dates, :price_per_night, :reservations, :room_total
    
    attr_accessor :daterange_factory, :room_factory, :rooms
    
    def initialize(id: 0, number_of_rooms:, start_date: nil, end_date: nil, price_per_night:)
      @id = id
      @price_per_night = price_per_night
      @room_total = number_of_rooms
      
      @reservations = []
      @daterange_factory = DateRangeFactory.new()
      @room_factory = RoomFactory.new()
      
      if !(start_date.nil? && end_date.nil?)
        @dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      end
      
      if start_date.nil? && end_date.nil? # then it's the default block
        @rooms = load_rooms(number_of_rooms)
      else
        @rooms = []
      end
    end
    
    def load_rooms(number_of_rooms)
      unless id == 0
        raise ArgumentError.new("Only default blocks can access this method")
      end
      
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << room_factory.make_room(room_number)
      end
      return rooms_list
    end
    
    def contains_room?(room_number)
      rooms.each do |block_room|
        if block_room.number == room_number
          return true
        end
      end
      return false
    end
    
    def add_reservation_to_list(reservation)
      unless reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{reservation}")
      end
      
      reservations << reservation
    end
    
  end
end