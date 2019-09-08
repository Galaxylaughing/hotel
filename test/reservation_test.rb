require_relative 'test_helper'

describe "Reservation" do
  
  describe "initialize" do
    let(:reservation) {
      HotelBooking::Reservation.new(id: 10, start_date: "august 1 2019", end_date: "august 3 2019", price_per_night: 200.00)
    }
    
    it "creates a Reservation Object" do
      expect(reservation).must_be_instance_of HotelBooking::Reservation
    end
    
    it "knows its ID" do
      expect(reservation.id).must_equal 10
    end
    
    it "knows its price per night" do
      expect(reservation.price_per_night).must_equal 200.00
    end
    
    it "has a DateRange" do
      expect(reservation.dates).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can read its DateRange start_date" do
      expect(reservation.dates.start_date.to_s).must_equal "2019-08-01"
    end
    
    it "can read its DateRange end_date" do
      expect(reservation.dates.end_date.to_s).must_equal "2019-08-03"
    end
    
  end
  
  describe ".make_dates" do
    let(:result) {
      HotelBooking::Reservation.make_dates(start_date: "august 1 2019", end_date: "august 3 2019")
    }
    
    it "returns a DateRange" do
      expect(result).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can access the start date" do
      expect(result.start_date.to_s).must_equal "2019-08-01"
    end
    
    it "can access the end date" do
      expect(result.end_date.to_s).must_equal "2019-08-03"
    end
    
    it "raises an exception is given invalid dates" do
      expect {
        HotelBooking::Reservation.make_dates(start_date: "cookie", end_date: "monster")
      }.must_raise ArgumentError
    end
    
  end
  
  describe "#total_price" do
    let(:reservation_one) {
      HotelBooking::Reservation.new(id: 11, start_date: "august 1 2019", end_date: "august 3 2019", price_per_night: 200.00)
    }
    let(:reservation_two) {
      HotelBooking::Reservation.new(id: 12, start_date: "august 1 2019", end_date: "august 30 2019", price_per_night: 200.00)
    }
    
    it "returns a float" do
      expect(reservation_one.total_price).must_be_instance_of Float
    end
    
    it "can total the price for a short reservation" do
      expect(reservation_one.total_price).must_equal 400.00
    end
    
    it "can total the price for a long reservation" do
      expect(reservation_two.total_price).must_equal 5_800.00
    end
    
  end
  
  describe "#includes_date" do
    let(:start_date) {
      "feb 3 2019"
    }
    let(:end_date) {
      "feb 6 2019"
    }
    
    it "should return true for date that occurs in the input's middle" do
      reservation = HotelBooking::Reservation.new(id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      expect(reservation.includes_date("feb 4 2019")).must_equal true
    end
    
    it "should return: date that matches the input's check-in day" do
      reservation = HotelBooking::Reservation.new(id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      expect(reservation.includes_date(start_date)).must_equal true
    end
    
    it "should NOT return: date that matches the input's check-out day" do
      reservation = HotelBooking::Reservation.new(id: 1, start_date: start_date, end_date: end_date, price_per_night: 200.00)
      
      expect(reservation.includes_date(end_date)).must_equal false
    end
  end
  
end
