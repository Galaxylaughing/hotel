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