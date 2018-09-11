defmodule Store.RuleServer do
  @moduledoc """
  Module that implements an Agent to store a Rules List
  """
  use Agent

  alias Store.Product

  @doc "Starts an Agent Process"
  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_) do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  @doc """
  Adds a rule function to the Agent Process

  ## Parameters
  - rule_function: A Rule function implemented into a rule module

  ## Examples
  iex> Store.RuleServer.add(&Store.Rules.MarketingRule.apply/1)

  :ok
  """
  @spec add(([Product.t()] -> Money.t())) :: :ok
  def add(rule_function) do
    Agent.cast(__MODULE__, &MapSet.put(&1, rule_function))
  end

  @doc "Returns all functions inside Agent's Process"
  @spec all() :: MapSet.t()
  def all do
    Agent.get(__MODULE__, & &1)
  end

  @doc "Clean agent"
  def clean do
    Agent.cast(__MODULE__, fn _ -> MapSet.new() end)
  end
end
