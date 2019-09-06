module HotelBooking
  class RoomFactory
    
    def make_room(room_number)
      return Room.new(room_number)
    end
    
  end
end
