require_relative 'test_helper'

describe "ReservationFactory" do
  let(:reservation_factory) {
    HotelBooking::ReservationFactory.new()
  }
  let(:room) {
    HotelBooking::Room.new(1)
  }
  
  describe "#make_reservation" do
    let(:new_reservation) {
      reservation_factory.make_reservation(id: 10, start_date: "jan 1 2019", end_date: "jan 3 2019", price_per_night: 200.00)
    }
    
    it "can create a Reservation instance" do
      expect(new_reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    it "can create a Reservation instance with a special price" do
      discounted_reservation = reservation_factory.make_reservation(id: 11, start_date: "jan 1 2019", end_date: "jan 3 2019", price_per_night: 150.00)
      
      expect(discounted_reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    it "can access the reservation's DateRange" do
      expect(new_reservation.dates).must_be_instance_of HotelBooking::DateRange
    end
    
    # logic is being handled in DateRange.initialize()
    it "throws an error if given an invalid dates" do
      expect {
        reservation_factory.make_reservation(id: 12, start_date: "cookie", end_date: "jan 3 2019", price_per_night: 200.00)
      }.must_raise ArgumentError
      
      expect {
        reservation_factory.make_reservation(id: 13, start_date: "jan 1 2019", end_date: "cookie", price_per_night: 200.00)
      }.must_raise ArgumentError
    end
    
  end
  
end