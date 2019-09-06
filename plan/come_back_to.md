Currently, Reservation.initialize defaults to 200.00.
It would be good if, after Hotel is created, Reservation.initialize could default to Hotel@cost_per_night.

It would be good if, after Hotel is created, Room expected a number in the range of however many rooms Hotel has.

Currently, there's a commented-out test in hotel_test.rb, because I can't figure out how to make @rooms un-modifiable, and there's the possiblity that the Hotel owners could expand and you'd want to be able to add more rooms. But even if you did allow it to add a room, it shouldn't be able to have the same room number as a room that already exists.

Maybe instead of having a bunch of Factory.new instances being instantiated, I could make them all modules and call that module?