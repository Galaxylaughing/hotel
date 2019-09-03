module HotelBooking
  class Reservation
    
    attr_reader :room, :dates, :cost_per_night
    
    def initialize(room, start_date, end_date, cost_per_night = 200.00)
      @room = room
      @cost_per_night = cost_per_night
      @dates = DateRange.new(start_date, end_date)
    end
    
    def total_cost()
      total_cost = cost_per_night * dates.nights
      return total_cost
    end
    
  end  
end
