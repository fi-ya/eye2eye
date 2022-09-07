defmodule Eye2eye.OrdersTest do
  use Eye2eye.DataCase

  import Eye2eye.OrdersFixtures

  alias Eye2eye.Orders

  describe "orders" do
    alias Eye2eye.Orders.Order

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
      valid_attrs = %{total_price: "120.00", user_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.total_price == Decimal.new("120.00")
      assert order.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end
  end

  describe "order_line_items" do
    alias Eye2eye.Orders.LineItem

    @invalid_attrs %{price: nil, quantity: nil}

    test "list_order_line_items/0 returns all order_line_items" do
      line_item = line_item_fixture()
      assert Orders.list_order_line_items() == [line_item]
    end

    test "get_line_item!/1 returns the line_item with given id" do
      line_item = line_item_fixture()
      assert Orders.get_line_item!(line_item.id) == line_item
    end

    test "create_line_item/1 with valid data creates a line_item" do
      valid_attrs = %{price: "120.50", quantity: 1}

      assert {:ok, %LineItem{} = line_item} = Orders.create_line_item(valid_attrs)
      assert line_item.price == Decimal.new("120.50")
      assert line_item.quantity == 1
    end

    test "create_line_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_line_item(@invalid_attrs)
    end
  end
end
