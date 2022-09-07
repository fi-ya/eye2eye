defmodule Eye2eye.OrdersTest do
  use Eye2eye.DataCase

  alias Eye2eye.Orders

  describe "orders" do
    alias Eye2eye.Orders.Order

    import Eye2eye.OrdersFixtures

    @invalid_attrs %{total_price: nil, user_uuid: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{total_price: "120.5", user_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.total_price == Decimal.new("120.5")
      assert order.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end
  end
end
