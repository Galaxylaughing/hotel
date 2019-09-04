module HotelBooking
  class Hotel
    
    attr_reader :room_total, :cost_per_night, :rooms, :reservations
    
    def initialize(number_of_rooms, cost_per_night)
      @room_total = number_of_rooms
      @cost_per_night = cost_per_night
      @rooms = load_rooms(number_of_rooms)
      @reservations = []
    end
    
    def load_rooms(number_of_rooms)
      rooms_list = []
      for room_number in 1..number_of_rooms
        rooms_list << Room.new(room_number)
      end
      return rooms_list
    end
    
    def make_reservation(start_date, end_date)
      chosen_room = rooms.sample
      
      new_reservation = Reservation.new(chosen_room, start_date, end_date)
      
      chosen_room.add_reservation(new_reservation)
      # hotel.add_reservation(new_reservation)
      
      return new_reservation
    end
    
  end
end