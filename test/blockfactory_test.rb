require_relative 'test_helper'

describe "BlockFactory" do
  let(:block_factory) {
    HotelBooking::BlockFactory.new()
  }
  let(:new_block) {
    block_factory.make_block(id: 1, number_of_rooms: 3, start_date: "feb 1 2019", end_date: "feb 22 2019", price_per_night: 160.00)
  }
  
  describe "#make_block" do
    
    it "can create a Block instance" do
      expect(new_block).must_be_instance_of HotelBooking::Block
    end
    
    it "must have access to its Block ID" do
      expect(new_block.id).must_equal 1
    end
    
    it "must have access to its number of rooms" do
      expect(new_block.rooms.length).must_equal 3
    end
    
    it "must have a DateRange" do
      expect(new_block.dates).must_be_instance_of HotelBooking::DateRange
      expect(new_block.dates.start_date).must_be_instance_of Date
      expect(new_block.dates.end_date).must_be_instance_of Date
    end
    
    it "must have a particular price" do
      expect(new_block.price_per_night).must_be_instance_of Float
      expect(new_block.price_per_night).must_equal 160.00
    end
    
  end
  
end