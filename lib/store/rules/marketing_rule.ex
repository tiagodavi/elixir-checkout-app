defmodule Store.Rules.MarketingRule do
  @moduledoc """
  Module that implements Marketing's Rule

  The marketing department believes in 2-for-1 promotions
  (buy two of the same product, get one free),
  and would like for there to be a 2-for-1 special on VOUCHER items.
  """

  alias Store.Product
  alias Store.Rules.RuleBehavior

  @behaviour RuleBehavior

  @doc """
  Implements Marketing's rule and returns either amount to add or amount to subtract

  ## Parameters
  - products: A Products list

  ## Examples
  iex> voucher = Store.Product.new("VOUCHER", "Voucher", 5_00)

  %Store.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :EUR}
  }

  iex> Store.Rules.MarketingRule.apply([voucher])

  %{
    sub: %Money{amount: 0, currency: :EUR},
    add: %Money{amount: 0, currency: :EUR}
   }
  """
  @spec apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
  def apply(products) do
    init = %{
      items: 0,
      sub: %Money{amount: 0, currency: :EUR},
      add: %Money{amount: 0, currency: :EUR}
    }

    result =
      products
      |> Stream.filter(fn p -> p.code === "VOUCHER" end)
      |> Enum.reduce(init, fn p, acc ->
        if acc.items === 1 do
          %{acc | items: 0, sub: Money.add(acc.sub, p.price)}
        else
          %{acc | items: acc.items + 1}
        end
      end)

    %{
      sub: result.sub,
      add: result.add
    }
  end
end
