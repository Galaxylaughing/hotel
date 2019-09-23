require_relative 'test_helper'

describe "Room" do
  
  describe "initialize" do
    let(:room) {
      HotelBooking::Room.new(1)
    }
    
    it "creates a Room Object" do
      expect(room).must_be_instance_of HotelBooking::Room
    end
    
    it "can read its room number" do
      expect(room.number).must_equal 1
    end
    
    it "will raise an exception if given an invalid room number" do
      expect {
        HotelBooking::Room.new("cookie")
      }.must_raise ArgumentError
    end
    
    it "must have a collection of reservations" do
      expect(room.reservations).must_be_instance_of Array
      room.reservations.each do |single_reservation|
        expect(single_reservation).must_be_instance_of HotelBooking::Reservation
      end
    end
    
    it "can add a Reservation to its list" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "august 1", end_date: "august 5", price_per_night: 200.00)
      room.reservations << reservation_one
      expect(room.reservations.length).must_equal 1
    end
    
  end
  
  describe "#add_reservation_to_list" do
    let(:room_one) {
      HotelBooking::Room.new(1)
    }
    let(:room_three) {
      HotelBooking::Room.new(3)
    }
    
    it "can add a new reservation" do
      new_reservation = HotelBooking::Reservation.new(id: 1, start_date: "august 1", end_date: "august 5", price_per_night: 200.00)
      
      room_one.add_reservation_to_list(new_reservation)
      expect(room_one.reservations.length).must_equal 1
    end
    
    it "raises an exception for an argument that isn't a Reservation Object" do
      new_reservation = "august 10th"
      expect {
        room_one.add_reservation_to_list(new_reservation)
      }.must_raise StandardError
    end
    
  end
  
  describe "#is_available?" do
    let(:room) {
      HotelBooking::Room.new(19)
    }
    let(:start_date) {
      "feb 3 2019"
    }
    let(:end_date) {
      "feb 7 2019"
    }
    
    it "IS available if it has no reservations in its list" do
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal true
    end
    
    it "IS available if none of its reservations overlap" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "jan 1 2019", end_date: "jan 8 2019", price_per_night: 200.00)
      reservation_two = HotelBooking::Reservation.new(id: 2, start_date: "jan 12 2019", end_date: "jan 14 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      room.reservations << reservation_two
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal true
    end
    
    #     3 4 5 6 7
    #     3 4 5 6 7
    it "is not available if it has a reservation that overlaps completely" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal false
    end
    
    #       4 5 6
    #     3 4 5 6 7
    it "is not available if it has a reservation that overlaps the input's middle" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "feb 4 2019", end_date: "feb 6 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal false
    end
    
    # 1 2 3 4
    #     3 4 5 6 7
    it "is not available if it has a reservation that overlaps the input's first two days" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "feb 1 2019", end_date: "feb 4 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal false
    end
    
    #           6 7 8 9
    #     3 4 5 6 7
    it "is not available if it has a reservation that overlaps the input's last two days" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "feb 6 2019", end_date: "feb 9 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal false
    end
    
    # 1 2 3
    #     3 4 5 6 7
    it "IS available if it has a reservation that ends on the input's check-in day" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "feb 1 2019", end_date: "feb 3 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal true
    end
    
    #         7 8 9
    # 3 4 5 6 7
    it "IS available if it has a reservation that begins on the input's check-out day" do
      reservation_one = HotelBooking::Reservation.new(id: 1, start_date: "feb 7 2019", end_date: "feb 9 2019", price_per_night: 200.00)
      
      room.reservations << reservation_one
      
      expect(room.is_available?(start_date: start_date, end_date: end_date)).must_equal true
    end
    
  end
  
  describe "#make_reservation" do
    let(:room) {
      HotelBooking::Room.new(1)
    }
    let(:result) {
      room.make_reservation(reservation_id: 1, start_date: "march 1 2019", end_date: "march 4 2019", price_per_night: 170.00)
    }
    
    it "can create a reservation instance" do
      expect(result).must_be_instance_of HotelBooking::Reservation
    end
    
    it "adds the reservation to its list" do
      result
      expect(room.reservations.length).must_equal 1
    end
    
    it "can add multiple reservations to its list" do
      result
      room.make_reservation(reservation_id: 2, start_date: "may 1 2019", end_date: "may 4 2019", price_per_night: 170.00)
      expect(room.reservations.length).must_equal 2
    end
    
    it "won't add an overlapping reservation" do
      room.make_reservation(reservation_id: 1, start_date: "march 1 2019", end_date: "march 4 2019", price_per_night: 170.00)
      
      expect {
        room.make_reservation(reservation_id: 2, start_date: "march 1 2019", end_date: "march 4 2019", price_per_night: 170.00)
      }.must_raise StandardError
    end
    
  end
  
  describe "#find_reservation_by_date" do
    let(:start_date) {
      "feb 3 2019"
    }
    let(:end_date) {
      "feb 6 2019"
    }
    let(:room) {
      HotelBooking::Room.new(1)
    }
    
    it "should return: date that occurs in the input's middle" do
      room.make_reservation(reservation_id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      overlapping_reservations = room.find_reservations_by_date("feb 4 2019")
      expect(overlapping_reservations.length).must_equal 1
    end
    
    it "should return: date that matches the input's check-in day" do
      room.make_reservation(reservation_id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      overlapping_reservations = room.find_reservations_by_date(start_date)
      expect(overlapping_reservations.length).must_equal 1
    end
    
    it "should NOT return: date that matches the input's check-out day" do
      room.make_reservation(reservation_id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      overlapping_reservations = room.find_reservations_by_date(end_date)
      expect(overlapping_reservations.length).must_equal 0
    end
    
  end
  
  describe "get_reservation_price" do
    let(:room) {
      HotelBooking::Room.new(1)
    }
    
    it "finds the price of a reservation" do
      room.make_reservation(reservation_id: 1, start_date: "march 1 2019", end_date: "march 4 2019", price_per_night: 100.00)
      
      expect(room.get_reservation_price(1)).must_equal (3 * 100.00)
    end
    
    it "returns nil for nonexistent reservations" do
      expect(room.get_reservation_price(10)).must_be_nil
    end
  end
  
end
