# Store
This application implements a checkout process.

* How to install Elixir? https://elixir-lang.org/install.html
* After installing, clone this project and install dependencies with `mix deps.get`
* Run tests with `mix test`

## USAGE

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
