module HotelBooking
  class Block
    
    attr_reader :id, :dates, :price_per_night, :reservations
    
    attr_accessor :daterange_factory, :room_factory, :rooms
    
    def initialize(id: 0, number_of_rooms:, start_date: nil, end_date: nil, price_per_night:)
      @id = id
      @price_per_night = price_per_night
      
      @reservations = []
      @daterange_factory = DateRangeFactory.new()
      @room_factory = RoomFactory.new()
      
      if !(start_date.nil? && end_date.nil?)
        @dates = daterange_factory.make_daterange(start_date: start_date, end_date: end_date)
      end
      
      @rooms = load_rooms(number_of_rooms)
    end
    
    def load_rooms(number_of_rooms)
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << room_factory.make_room(room_number)
      end
      return rooms_list
    end
    
    def add_reservation_to_list(reservation)
      unless reservation.class == Reservation
        raise ArgumentError.new("Invalid reservation; expected Reservation instance, received #{reservation}")
      end
      
      reservations << reservation
    end
    
  end
end