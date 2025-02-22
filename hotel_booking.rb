# gems any your project needs
require 'date'

# our namespace module
module HotelBooking; end

# all of our data classes that live in the module
require_relative "lib/daterange"
require_relative "lib/daterangefactory"
require_relative "lib/reservation"
require_relative "lib/reservationfactory"
require_relative "lib/room"
require_relative "lib/roomfactory"
require_relative "lib/block"
require_relative "lib/blockfactory"
require_relative "lib/hotel"
