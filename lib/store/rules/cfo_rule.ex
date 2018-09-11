defmodule Store.Rules.CFORule do
  @moduledoc """
  Module that implements CFO's Rule

  The CFO insists that the best way to increase sales is with discounts on bulk purchases
  (buying x or more of a product, the price of that product is reduced), and demands
  that if you buy 3 or more TSHIRT items, the price per unit should be 19.00€.
  """

  alias Store.Rules.RuleBehavior

  @behaviour RuleBehavior

  @doc """
  Implements CFO's rule and returns either amount to add or amount to subtract

  ## Parameters
  - products: A Products list

  ## Examples
  iex> voucher = Store.Product.new("VOUCHER", "Voucher", 5_00)

  %Store.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :EUR}
  }

  iex> Store.Rules.CFORule.apply([voucher])

  %{
    sub: %Money{amount: 0, currency: :EUR},
    add: %Money{amount: 0, currency: :EUR}
   }
  """
  @spec apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
  def apply(products) do
    bulk_limit = 3
    discount = %Money{amount: 1_00, currency: :EUR}

    init = %{
      sub: %Money{amount: 0, currency: :EUR},
      add: %Money{amount: 0, currency: :EUR}
    }

    total_tshirts =
      products
      |> Stream.filter(fn p -> p.code === "TSHIRT" end)
      |> Enum.count()

    if total_tshirts >= bulk_limit do
      Enum.reduce(1..total_tshirts, init, fn _, acc ->
        %{acc | sub: Money.add(acc.sub, discount)}
      end)
    else
      init
    end
  end
end
