defmodule Store.ProductServer do
  @moduledoc """
  Module that implements an Agent to store a Products List
  """
  use Agent

  @doc "Starts an Agent Process"
  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Adds a product to the Agent Process

  ## Parameters
  - product: A Product struct

  ## Examples
  iex> voucher = Store.Product.new("VOUCHER", "Voucher", 5_00)

  %Store.Product{
    code: "VOUCHER",
    name: "Voucher",
    price: %Money{amount: 500, currency: :EUR}
  }

  iex> Store.ProductServer.add(voucher)

  :ok
  """
  @spec add(Product.t()) :: :ok
  def add(product) do
    Agent.cast(__MODULE__, &[product | &1])
  end

  @doc "Returns all products inside Agent's Process"
  @spec all() :: [Product.t()]
  def all do
    Agent.get(__MODULE__, & &1)
  end

  @doc "Clean agent"
  def clean do
    Agent.cast(__MODULE__, fn _ -> [] end)
  end
end
