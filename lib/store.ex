defmodule Store do
  @moduledoc """
  Module that implements Store's public interface
  """

  alias Store.Product
  alias Store.ProductServer
  alias Store.RuleServer

  @doc """
  Adds a rule to the checkout process

  ## Parameters
  - rule: A Rule module that implements Rules' Behavior

  ## Examples
  iex> Store.add_rule(Store.Rules.MarketingRule)

  {:ok, Store.Rules.MarketingRule}
  """
  @spec add_rule(module()) :: {:ok, module()}
  def add_rule(rule) do
    {RuleServer.add(&rule.apply/1), rule}
  end

  @doc """
  Scans a product

  ## Parameters
  - product: A Product struct

  ## Examples
  iex> voucher = Store.Product.new("VOUCHER", "Voucher", 5_00)

  %Store.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :EUR}
  }

  iex> Store.scan(voucher)

  {:ok, %Store.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :EUR}
  }}
  """
  @spec scan(Product.t()) :: {:ok, Product.t()}
  def scan(product) do
    {ProductServer.add(product), product}
  end

  @doc "Applies rules and calculates final price"
  @spec total() :: String.t()
  def total do
    products = ProductServer.all()
    rules = RuleServer.all()

    rules_result =
      Enum.map(rules, fn rule ->
        rule.(products)
      end)

    total =
      Enum.reduce(products, Money.new(0, :EUR), fn p, acc ->
        Money.add(acc, p.price)
      end)

    final_price =
      Enum.reduce(rules_result, total, fn r, acc ->
        acc
        |> Money.add(r.add)
        |> Money.subtract(r.sub)
      end)

    final_price
    |> Money.to_string(
      separator: ",",
      delimeter: ".",
      symbol: true,
      symbol_on_right: true
    )
  end
end
