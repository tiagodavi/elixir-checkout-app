# Store
Elixir Application that implements a checkout process.

* How to install Elixir? https://elixir-lang.org/install.html
* After installing, clone this project and install dependencies with `mix deps.get`
* Run tests with `mix test`
* Format your code with `mix format`
* Check refactoring opportunities with `mix credo --strict`

### Usage

```elixir
voucher = Store.Product.new("VOUCHER", "Voucher", 750)
# %Store.Product{
#     code: "VOUCHER",
#     name: "Voucher",
#     price: %Money{amount: 750, currency: :EUR}
# }

store = Store.new(pricing_rules)
store.scan(voucher)
total = store.total()
```

### Settings:

  - This project uses [`Credo`](https://github.com/rrrene/credo) and [`Formatter`](https://medium.com/blackode/code-formatter-the-big-feature-in-elixir-v1-6-0-f6572061a4ba) to ensure quality
  - Created on Mac OS Sierra 10.12.2
  - IDE Atom 1.28.2
