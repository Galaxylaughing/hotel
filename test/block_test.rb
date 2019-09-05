require_relative 'test_helper'

describe "Block" do
  
  describe "initialize" do
    let(:block) {
      HotelBooking::Block.new(id: 1, start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
    }
    
    it "can create a Block instance" do
      expect(block).must_be_instance_of HotelBooking::Block
    end
    
    it "has an id" do
      expect(block.id).must_be_instance_of Integer
      expect(block.id).must_equal 1
    end
    
    it "has a DateRange" do
      expect(block.dates).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can read its start date" do
      expect(block.dates.start_date.to_s).must_equal "2019-12-10"
    end
    
    it "can read its end date" do
      expect(block.dates.end_date.to_s).must_equal "2019-12-20"
    end
    
    it "has a price per night" do
      expect(block.price_per_night).must_be_instance_of Float
      expect(block.price_per_night).must_equal 150.00
    end
    
    it "has a list of Rooms" do
      expect(block.rooms).must_be_instance_of Array
      block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
    
  end
  
  # same as Hotel
  describe ".make_daterange" do
    let(:result) {
      HotelBooking::Block.make_daterange(start_date: "january 2, 2019", end_date: "january 20, 2019")
    }
    
    it "returns a DateRange instance" do
      expect(result).must_be_instance_of HotelBooking::DateRange
    end
    
    it "can read its start date" do
      expect(result.start_date.to_s).must_equal "2019-01-02"
    end
    
    it "can read its end date" do
      expect(result.end_date.to_s).must_equal "2019-01-20"
    end
  end
  
  describe "#add_room" do
    let(:block) {
      HotelBooking::Block.new(id: 1, start_date: "december 10 2019", end_date: "december 20 2019", price_per_night: 150.00)
    }
    let(:room_ten) {
      HotelBooking::Room.new(10)
    }
    
    it "adds a room to the block's list of rooms" do
      block.add_room(room_ten)
      expect(block.rooms.length).must_equal 1
      block.rooms.each do |block_room|
        expect(block_room).must_be_instance_of HotelBooking::Room
      end
    end
  end
  
end
