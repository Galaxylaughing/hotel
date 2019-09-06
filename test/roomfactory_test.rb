require_relative 'test_helper'

describe "RoomFactory" do
  let(:room_factory) {
    HotelBooking::RoomFactory.new()
  }
  
  describe "#make_room" do
    
    it "can create a Room instance" do
      expect(room_factory.make_room(3)).must_be_instance_of HotelBooking::Room
    end
    
    # logic is being handled in Room.initialize()
    it "throws an error if given an invalid room number" do
      expect {
        room_factory.make_room("cookie")
      }.must_raise ArgumentError
    end
    
  end
  
end