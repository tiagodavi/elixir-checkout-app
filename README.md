# Store
Elixir Application that implements a checkout process.

* How to install Elixir? https://elixir-lang.org/install.html
* After installing, clone this project and install dependencies with `mix deps.get`
* Run tests with `mix test`
* Format your code with `mix format`
* Check refactoring opportunities with `mix credo --strict`
* Prepare for running `iex -S mix`

### Usage

```elixir
voucher1 = Store.Product.new("VOUCHER", "voucher", 5_00)
voucher2 = Store.Product.new("VOUCHER", "voucher", 5_00)
voucher3 = Store.Product.new("VOUCHER", "voucher", 5_00)

tshirt1 = Store.Product.new("TSHIRT", "T-Shirt ", 20_00)
tshirt2 = Store.Product.new("TSHIRT", "T-Shirt ", 20_00)
tshirt3 = Store.Product.new("TSHIRT", "T-Shirt ", 20_00)

mug = Store.Product.new("MUG", "Coffee Mug", 7_50)

Store.add_rule(Store.Rules.MarketingRule)
Store.add_rule(Store.Rules.CFORule)

Store.scan(voucher1)
Store.scan(voucher2)
Store.scan(voucher3)

Store.scan(tshirt1)
Store.scan(tshirt2)
Store.scan(tshirt3)

Store.scan(mug)

Store.total() #"74.50€"
```

### Why?

- Money type instead of :float -> :float is a bad decision for money. Money type is safer
- RuleBehavior -> It's easy to create a new rule
- Agent instead of GenServer -> Agent is simpler to store state
- Credo -> Just to ensure code quality
- Format -> Just to ensure code quality

### Settings

  - This project uses [`Credo`](https://github.com/rrrene/credo) and [`Formatter`](https://medium.com/blackode/code-formatter-the-big-feature-in-elixir-v1-6-0-f6572061a4ba) to ensure quality
  - Created on Mac OS Sierra 10.12.2
  - IDE Atom 1.28.2
