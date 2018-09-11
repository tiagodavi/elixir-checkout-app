defmodule Store.Rules.RuleBehavior do
  @moduledoc """
  Module that implements Rules' Behavior
  """

  alias Store.Product

  @callback apply([Product.t()]) :: %{sub: Money.t(), add: Money.t()}
end
