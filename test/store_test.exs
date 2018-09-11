defmodule StoreTest do
  use ExUnit.Case, async: true

  alias Store.Product
  alias Store.ProductServer
  alias Store.Rules.{CFORule, MarketingRule}
  alias Store.RuleServer

  setup do
    ProductServer.clean()
    RuleServer.clean()
    :ok
  end

  describe ".add_rule" do
    test "avoid duplicated rules" do
      assert {:ok, MarketingRule} == Store.add_rule(MarketingRule)
      assert {:ok, MarketingRule} == Store.add_rule(MarketingRule)
      assert {:ok, CFORule} == Store.add_rule(CFORule)
      assert {:ok, CFORule} == Store.add_rule(CFORule)

      rules = RuleServer.all()

      assert Enum.count(rules) == 2
    end
  end

  test ".scan" do
    voucher = Product.new("VOUCHER", "Voucher", 5_00)
    assert {:ok, _} = Store.scan(voucher)
    assert {:ok, _} = Store.scan(voucher)

    products = ProductServer.all()

    assert Enum.count(products) == 2
  end

  describe ".total" do
    test "returns '0.00€' when there are no products" do
      assert Store.total() == "0.00€"
    end

    test "VOUCHER, TSHIRT, MUG should be 32.50€" do
      voucher = Product.new("VOUCHER", "voucher", 5_00)
      tshirt = Product.new("TSHIRT", "T-Shirt ", 20_00)
      mug = Product.new("MUG", "Coffee Mug", 7_50)

      assert {:ok, _} = Store.add_rule(MarketingRule)
      assert {:ok, _} = Store.add_rule(CFORule)
      assert {:ok, _} = Store.scan(voucher)
      assert {:ok, _} = Store.scan(tshirt)
      assert {:ok, _} = Store.scan(mug)

      assert Store.total() == "32.50€"
    end

    test "VOUCHER, TSHIRT, VOUCHER should be 25.00€" do
      voucher1 = Product.new("VOUCHER", "voucher", 5_00)
      voucher2 = Product.new("VOUCHER", "voucher", 5_00)
      tshirt = Product.new("TSHIRT", "T-Shirt ", 20_00)

      assert {:ok, _} = Store.add_rule(MarketingRule)
      assert {:ok, _} = Store.add_rule(CFORule)
      assert {:ok, _} = Store.scan(voucher1)
      assert {:ok, _} = Store.scan(voucher2)
      assert {:ok, _} = Store.scan(tshirt)

      assert Store.total() == "25.00€"
    end

    test "TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT should be 81.00€" do
      voucher = Product.new("VOUCHER", "voucher", 5_00)
      tshirt1 = Product.new("TSHIRT", "T-Shirt ", 20_00)
      tshirt2 = Product.new("TSHIRT", "T-Shirt ", 20_00)
      tshirt3 = Product.new("TSHIRT", "T-Shirt ", 20_00)
      tshirt4 = Product.new("TSHIRT", "T-Shirt ", 20_00)

      assert {:ok, _} = Store.add_rule(MarketingRule)
      assert {:ok, _} = Store.add_rule(CFORule)
      assert {:ok, _} = Store.scan(voucher)
      assert {:ok, _} = Store.scan(tshirt1)
      assert {:ok, _} = Store.scan(tshirt2)
      assert {:ok, _} = Store.scan(tshirt3)
      assert {:ok, _} = Store.scan(tshirt4)

      assert Store.total() == "81.00€"
    end

    test "VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT should be 74.50€" do
      voucher1 = Product.new("VOUCHER", "voucher", 5_00)
      voucher2 = Product.new("VOUCHER", "voucher", 5_00)
      voucher3 = Product.new("VOUCHER", "voucher", 5_00)

      tshirt1 = Product.new("TSHIRT", "T-Shirt ", 20_00)
      tshirt2 = Product.new("TSHIRT", "T-Shirt ", 20_00)
      tshirt3 = Product.new("TSHIRT", "T-Shirt ", 20_00)

      mug = Product.new("MUG", "Coffee Mug", 7_50)

      assert {:ok, _} = Store.add_rule(MarketingRule)
      assert {:ok, _} = Store.add_rule(CFORule)

      assert {:ok, _} = Store.scan(voucher1)
      assert {:ok, _} = Store.scan(voucher2)
      assert {:ok, _} = Store.scan(voucher3)

      assert {:ok, _} = Store.scan(tshirt1)
      assert {:ok, _} = Store.scan(tshirt2)
      assert {:ok, _} = Store.scan(tshirt3)

      assert {:ok, _} = Store.scan(mug)

      assert Store.total() == "74.50€"
    end
  end
end
