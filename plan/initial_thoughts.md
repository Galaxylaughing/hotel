# OVERVIEW
modules: Booking
classes: Hotel, Reservation, DateRange
- a Hotel has many Reservations
- a Hotel has many Rooms
- a Room has many Reservations
- a Reservation has one Room
- a Reservation has one DateRange


## Booking
the module that has all the classes.

## Hotel
- (integer) number of rooms => 20
- (array) Reservation instances
- (float) cost per night of a room => $200/night
- (array) Room instances
// alternatively, (array) integers (or symbols), representing rooms

+ Hotel.initialize()
  * inputs: number of rooms, cost per night of a room

+ Hotel.create_rooms()
  * inputs: number_of_rooms
  * initializes a number of Room instances
  * puts each instance into the list of Rooms
// alternatively, adds an integer for each number to the list of Rooms

+ Hotel.all_rooms()
  * inputs: none
  * returns the Room instances array
// alternatively, outputs the array of room number integers

+ Hotel#make_reservation()
  * inputs: start_date, end_date
  * raises exception if given an invalid date range
  * finds Room that is available on those dates
  * creates Reservation instance with those dates
  * adds Reservation instance to Hotel@reservations
// or should Reservation.initialize add to Hotel@reservations?
  * returns a Reservation instance

+ Hotel#find_available_rooms()
  * inputs: start_date, end_date
  - for a given date range, what rooms are available?
    - duplicate Hotel@rooms.
    - look through Hotel@reservations.
    - check each Reservation's date range against the given date range.
    - if the Reservation overlaps the given date range,
      * (bear in mind, a reservation can start on the same date that another reservation ends, so the last date of the Reservation@dates should not be counted for this)
    - check its room number.
    - call Room#find_by_id and pass in that room number.
    - remove that Room instance from the copy of Hotel@rooms.
    - once all Reservations have been checked,
    - return the copy of Hotel@rooms, now without those that are reserved
  * returns list of Room instances

// alternatively,
you Hotel@rooms is an array of integers.
look through Hotel@reservations.
check each Reservation's date range against the given date range.
if the ranges overlap,
check that Reservations' room number
remove that room number integer from the copy of Hotel@rooms array of integers.
return the copy of Hotel@rooms.

// alternatively alternatively,
look through Hotel@rooms,
ask each room, are you available during this DateRange?
this would trigger room to check its reservations, and ask if they overlap with the DateRange
first room that is available is put into an array of available rooms
this list is what is returned


## Reservation
- (integer) reservation ID
// maybe a reservation ID is unnecessary?
- (integer) room number
- (array) dates

+ Reservation.initialize()
  * inputs: start_date, end_date, room_number
  * raise an exception if you try to make a reservation that would overlap another
    * call Reservation.find_by_date()
    * if there are any Reservations with overlapping date,
    * check their associated room number
    * raise exception if this number matches the input room number
  * adds Reservation instance to Hotel@reservations
// or should Hotel.make_reservation() add to Hotel@reservations?

+ Reservation.find_by_id()
  * inputs: reservation ID
  * returns a Reservation instance with that ID
// maybe unnecessary; does anything call Reservation.find_by_id()?
// Reservation.find_cost() calls Reservation.find_by_id()

+ Reservation.find_by_date()
  * inputs: start_date, end_date
  * finds all Reservation instances that overlap that date range
    * (calls Hotel@reservations to get a list of all Reservations?)
  * returns a list of Reservation instances

+ Reservation.find_cost()
  * inputs: reservation ID
  * calls Reservation.find_by_ID
  * finds the dates associated with that Reservation
  * finds the room associated with that Reservation
  * uses Hotel@cost_per_night and Reservation@dates to calculate the total_cost
    * (cost is per night, so that's the total number of days minus one)
  * returns the total cost of that Reservation
// or this is called on a Reservation instance, in which case Reservation.find_by_id() is unnecessary.


## DateRange
You could have a DateRange class, an instance of which is assigned to each Reservation.
 - (integer) start_date
 - (integer) end_date
 - (integer) number of nights

+ DateRange.initialize()
  * inputs: start_date, end_date
  * transforms intputs into Dates using DateRange.parse()

+ DateRange.is_valid?()
  * inputs: start_date, end_date
  * checks if date range is valid
  *   (e.g. end_date is not before start_date, end_date and start_date aren't the same date)
  * returns a boolean

+ DateRange.parse()
  * inputs: a date
  * transforms intputs into Dates using Date.parse()
  * returns a Date

+ DateRange#how_many_nights?()
  * inputs: none. called on a DateRange instance.
  * returns (integer) num_of_nights

what about a DateRange#overlaps?(other_daterange) method?


## Room
- (integer) room number
- (array) Reservation instances

+ Room.initialize()
  * inputs: room_number
  * adds Room instance to Hotel@rooms

+ Room.find_by_id()
  * inputs: room number
  * returns a Room instance with that room number

+ Room#is_available?()
  * inputs: DateRange
  * looks through (array) Reservation instances
  * checks if any instance overlaps (calls DateRange#overlaps?) the input DateRange
  * returns boolean


# PROGRAM

### thoughts:
- a one-day reservation should count as an invalid date range. a valid date range must include at least one night.
- how to determine how many nights?
  - if you have two days, that's one night
  - if you have three days, that's two nights
  - if you have five days, that's four nights
  - number of nights = number of days - 1

## Wave 1: Tracking Reservations
- / method: output list of all rooms in the hotel
- / method: input date range, makes a reservation
  - / raises an exception: when an invalid date range is provided
- / method: input date, output list of reservations on that date
- / method: input reservation ID, output total cost of a given reservation

Checkout occurs during the day. A customer is not charged for the final day of their stay, because it is not a night. Customers are only charged by the night.

## Wave 2: Room Availability
- / method: input date range, output all available rooms
- prevent overlapping reservations
- / raise an exception if you try to make a reservation that would overlap another

Reservations can start on the same day that another reservation ends.


## Wave 3: Hotel Blocks
a hotel block is a group of rooms set aside for a specific period of time.
specific customers can reserve them as a discounted price.

- method: input date range, list of rooms, and a discounted rate/night => creates a block
- raise an exception if one of the rooms is already reserved during that date range.
- prevent rooms inside the block from being reserved through normal means.
- prevent the creation of blocks that have overlapping rooms on overlapping dates.
- method: input block, output which rooms are available within that block.
- method: reserve a room inside a block (must be reserved for the full duration of the block)

- block reservations should be included in Reservation.find_by_date.

A block can contain a maximum of 5 rooms.

### thoughts on Wave 3:
A block seems like a mini-hotel, essentially. Like a sub-hotel that exists only over a certain period of time.
* like Hotel, it has a set of rooms, a cost per night, and a list of Reservation instances.
* like Hotel, it might have a self.all_rooms() method, a self.make_reservation() method, and a self.find_available_rooms() method.

Maybe you could have an abstract class Reservable that Hotel and Block inherit from.
- self.initialize(cost_per_night)
  * Hotel adds number_of_rooms.
  * Block adds array_of_rooms, which must be a subset of Hotel@rooms no greater than five rooms in size.

- self.all_rooms() returns a list of all the rooms, working basically the same.

- self.make_reservation() might work basically the same,
  * except Hotel adds the new reservation to Hotel@reservations,
  * while Block adds the new reservation to Block@reservations.

- self.find_available_rooms() would be similar,
  * but Block would need to ensure the date range matches its date range.
  * instead of looking through Hotel@reservations, Block would look through its own Block@reservations.

How would you prevent Hotel from being able to reserve a room already reserved by a Block?
  - Reservation.initialize() needs to add each Reservation to Hotel@reservations, so Hotel.find_available_rooms() can see it,
  - Reservation could have an Reservation.all() method that returns all reservations, both by Hotel and by any blocks,
  - when Block.make_reservation() runs, Block adds the reservation to its own list and Hotel@reservations.

How would you prevent Hotel from being able to reserve a room in the block?
  - some sort of bogus reservation in the Hotel@reservations?
  - or the Hotel has to ask the Block if it has a room during a date before you can reserve that room.
