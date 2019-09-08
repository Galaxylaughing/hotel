require_relative 'test_helper'

describe "BlockFactory" do
  let(:block_factory) {
    HotelBooking::BlockFactory.new()
  }
  let(:new_block) {
    block_factory.make_block(id: 1, room_numbers: Array(1..3), start_date: "feb 1 2019", end_date: "feb 22 2019", price_per_night: 160.00)
  }
  
  describe "#make_block" do
    
    it "can create a Block instance" do
      expect(new_block).must_be_instance_of HotelBooking::Block
    end
    
    it "can pass in a room source" do
      block_factory.make_block(id: 1, room_numbers: Array(1..3), start_date: "feb 1 2019", end_date: "feb 22 2019", price_per_night: 160.00, room_source: new_block)
    end
    
  end
  
end