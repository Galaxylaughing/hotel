module HotelBooking
  class Room
    
    attr_reader :number, :reservations
    
    def initialize(room_number)
      unless room_number.to_i > 0 && room_number.to_i < 21
        raise ArgumentError.new("Invalid room number; expected an integer between 1 and 20, received #{room_number}")
      end
      
      @number = room_number
      @reservations = []
    end
    
  end
end