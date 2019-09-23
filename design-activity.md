# Hotel Revisited

| link |
| -- |
| [hotel revisited](https://github.com/Ada-Developers-Academy/textbook-curriculum/blob/master/02-intermediate-ruby/exercises/hotel-revisited.md) |

## Activity: Evaluating Responsibility

Implementation A:

```ruby .line-numbers
  class CartEntry
    attr_accessor :unit_price, :quantity
    def initialize(unit_price, quantity)
      @unit_price = unit_price
      @quantity = quantity
    end
  end

  class ShoppingCart
    attr_accessor :entries
    def initialize
      @entries = []
    end
  end

  class Order
    SALES_TAX = 0.07
    def initialize
      @cart = ShoppingCart.new
    end

    def total_price
      sum = 0
      @cart.entries.each do |entry|
        sum += entry.unit_price * entry.quantity
      end
      return sum + sum * SALES_TAX
    end
  end
```


Implementation B:

```ruby .line-numbers
  class CartEntry
    def initialize(unit_price, quantity)
      @unit_price = unit_price
      @quantity = quantity
    end

    def price
      return @unit_price * @quantity
    end
  end

  class ShoppingCart
    def initialize
      @entries = []
    end

    def price
      sum = 0
      @entries.each do |entry|
        sum += entry.price
      end
      return sum
    end
  end

  class Order
    SALES_TAX = 0.07
    def initialize
      @cart = ShoppingCart.new
    end

    def total_price
      subtotal = @cart.price
      return subtotal + subtotal * SALES_TAX
    end
  end
```

Questions:

* What classes does each implementation include? Are the lists the same?
  * Both implementations use the same three classes: CartEntry, ShoppingCart, and Order.

* Write down a sentence to describe each class.
  * `CartEntry` represents the items in a customer's shopping cart, which itself is represented by the class `ShoppingCart`. `Order` represents the checkout order, where all of the items in a customer's cart are removed and paid for.
  * `CartEntry` is responsible for a single item that a customer can purchase.
  * `ShoppingCart` is responsible for knowing all of the items a customer intends to purchase.
  * `Order` is responsible for finding the total (after-tax) cost of a set of items.

* How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
  * In both implementations, an `Order` has one `ShoppingCart`, stored in it's `@cart` instance variable, and a `ShoppingCart` has an array of `CartEntries`, stored in its `@entries` instance variable.

* What **data** does each class store? How (if at all) does this differ between the two implementations?
  * In both implementations, `CartEntry` has a `unit_price` and a `quantity`, likely a float and an integer. `ShoppingCart` has its array of entries, and `Order` has its shopping cart and a constant, `SALES_TAX`, which is a float.

* What **methods** does each class have? How (if at all) does this differ between the two implementations?
  * In Implementation A:
    * `CartEntry` has a reader and writer method for `@unit_price` and `@quantity`.
    * `ShoppingCart` has a reader and writer method for `@entries`.
    * `Order` has the method `total_price`.
  * In Implementation B:
    * `CartEntry` has the method `price`, and does not have a reader or writer method for either of its instance variables.
    * `ShoppingCart` has the method `price`, and also does not have a reader or writer method for its instance variable.
    * `Order` has the same method as in Implementation A: `total_price`.

* Consider the `Order#total_price` method. In each implementation:
  * Is logic to compute the price delegated to "lower level" classes like `ShoppingCart` and `CartEntry`, or is it retained in `Order`?
    * In Implementation A, `Order` retains all of the logic necessary to calculate the total price.
    * In Implemenation B, `Order` delegates the part of the logic that calculates the before-tax total to `ShoppingCart`.
  * Does `total_price` directly manipulate the instance variables of other classes?
    * In Implementation A, `total_price` does directly manipulate other classes' instance variables: the method calls the reader method for `@entries` in the `Order`'s `@cart`, and then calls the reader methods for `@unit_price` and `@quantity` on each of those `CartEntries`.
    * In Implemenation B, `total_price` does not directly manipulate other classes' instance variables. Instead, it calls the `ShoppingCart`'s method `price` which in turn calls the `CartEntry`'s method `price` for each `CartEntry` in the `ShoppingCart`.

* If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
  * It would be more difficult to change in Implementation A. You would have to have logic inside `Order#total_price` that would check the `@quantity` of each `CartEntry` in the `@cart` and then change the `@unit_price` of that entry based on the `@quantity`. That or you would need some way of allowing `@quantity` to change the `@unit_price` of a `CartEntry`, perhaps using a `@bulk_discount` variable.
  * It would be easier to change in Implementation B, because you wouldn't have to change `Order`. You would only have to change `CartEntry#price`, which would perhaps respect a `@bulk_discount` instance variable on `CartEntry` or something like that.

* Which implementation better adheres to the single responsibility principle?
  * In Implementation B, `CartEntry` is responsible for a single item that a customer can purchase. As such, it needs to know that item's unit_price and quantity and it needs to be able to determine that item's price based off those two elements.
  * Similarly, `ShoppingCart` is responsible for all of the items a customer intends to purchase. It needs to know what these items are and it needs to be able to determine what the subtotal of those items will be.
  * `Order` is responsible for finding the total (after-tax) cost of a set of items. As such, it is _not_ responsible for knowing about any of the items in particular; `Order` does not contain any `CartEntries`, so it shouldn't need to know that `CartEntry` even exists. It should only talk to its set of entries, represented by its `@cart` `ShoppingCart`. Implementation B respects this responsibility scheme, but Implentation A does not.

* Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
  * While both implementations rely on certain things being true about other objects, Implementation B relies on less and is thus more loosely coupled.
  * In Implementation A, `Order` needs to know not only that it has a `ShoppingCart`, but _also_ that `ShoppingCart` has `CartEntries`, _and_ that `CartEntries` have `unit_prices` and `quantities`. This means that, if you did want to change the logic of how `CartEntry`'s price was calculated, you don't only have to change `CartEntry`, you _also_ have to change `Order`, which is not even directly connected to `CartEntry`.
  * In Implementation B, `Order` only knows that it has a `ShoppingCart` and that `ShoppingCart` has a `#price` method. You would even extract `ShoppingCart.new` from the initializer and enter the object in as a variable, and then theoretically you could give `Order` anything that has a `#price` method. In turn, all `ShoppingCart` knows is that it has an array of objects and each of those objects will respond to `#price`. You don't start dealing with `CartEntry`'s instance variables until you get to `CartEntry` itself. So if you needed to change the logic of how `CartEntry`'s price is calculated, you only need to change `CartEntry` itself.

## Revisiting Hotel

#### Class Questions
For each class in your program, ask yourself the following questions:

* What is this class's responsibility? (You should be able to describe it in a single sentence).
  * a Hotel is responsible for a set of Blocks.
  * a Block is responsible for a given set of rooms over a given set of dates.
  * a Room is responsible for a single room's data.
  * a Reservation is responsible for a single reservation's data.
  * a DateRange is responsible for a period of time defined by a start date and an end date.

* Is this class responsible for exactly one thing?
  * Pretty much. A Hotel has Blocks, which have Rooms, which have Reservations. The exception is that DateRanges are used by multiple classes.
  * For some reason, I have `@reservations = []` in Block, but that doesn't actually get used. I think I just failed to delete it after a refactor.

* Does this class take on any responsibility that should be delegated to "lower level" classes?
  * I think each class delegates pretty fully.
  * When Hotel wants to get information from its Blocks, it asks its Blocks for that information. If it wants to do something with rooms, it asks its Blocks to do it and those Blocks ask their Rooms. If it wants to make a reservation, it asks a Block to do it and that Block asks a Room.
  * Same with Block; it has Rooms, so if it wants to do anything, it has to tell its Rooms. If it wants to reserve a room, it asks a Room to make a Reservation. If it wants to know if it has any rooms available for a date, it asks each Room if its available for that date.
  * Same again with Room; if a Room wants to know if it has a Reservation for a date, it asks all of its Reservations, 'are you on this date?' If it wants to know the price of one of its Reservations, it asks the Reservation to calculate its price.
  * Reservations are pretty low on the totem pole. Except for asking its DateRange to check if it overlaps something, it doesn't delegate but rather other objects delegate to it.
  * DateRange also doesn't really delegate; its the very bottom level. Other objects delegate to it.

* Is there code in other classes that directly manipulates this class's instance variables?
  * I didn't see any and Kaida's comments didn't mention anything about this issue.

#### Refactor.txt Questions
Take a look at the refactor plans that you wrote, and consider the following:

* How easy is it to follow your own instructions?
  * My instructions are pretty straightforward and detailed.
* Do these refactors improve the clarity of your code?
  * I think so.
* Do you still agree with your previous assesment, or could your refactor be further improved?
  * I agree with my previous assessment.

#### Activity

Based on the answers to each set of the above questions, identify one place in your Hotel project where a class takes on multiple roles, or directly modifies the attributes of another class. Describe in design-activity.md what changes you would need to make to improve this design, and how the resulting design would be an improvement.

* Block has a `@reservations` variable that it doesn't use. I will remove this variable.
* Hotel takes a keyword argument `number_of_rooms` but has an instance variable `room_total`. I'm changing these both to be `room_count`, and I will change Block to use `room_count` instead of `room_total`, too.
* In Reservation, I convert the input string into a new DateRange in order to call `DateRange#overlaps(date)` on the Reservation's DateRange. As I suggested in refactors.txt, I will change this so that Reservation delegates fully to DateRange, calling a `DateRange#includes?()` method that does that work of converting and calling `DateRange#overlaps?()`.
* In DateRange, I have the instance variables `@start_date` and `@end_date`. In `DateRange#overlaps()`, I use these variables to create a Ruby Range. As I suggested in refactors.txt, I will change DateRange's initializer to create a `@range` Range variable instead of a `@start_date` and `@end_date` variable. I will create two new helper methods called `start_date()` and `end_date()` that will return `range.begin` and `range.end`, using the Ruby Range methods `#begin` and `#end`. Then I will refactor `DateRange#overlaps()` to reference this `range` variable's reader method instead of making a new Range itself.
* In Room, I raise an ArgumentError if a room is already reserved. I'll change this to a custom error, AlreadyReservedError, which will also be used in Hotel and Block. I will also create a custom error InvalidDurationError for Block and another error available to all classes, NonexistentIdError, which will be used by Block and Hotel.
* I will change the name of the file `hotel_system.rb` to `hotel_booking.rb`.
