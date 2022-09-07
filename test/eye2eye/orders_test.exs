defmodule Eye2eye.OrdersTest do
  use Eye2eye.DataCase

  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.CatalogFixtures
  import Eye2eye.OrdersFixtures

  alias Eye2eye.ShoppingCart
  alias Eye2eye.Orders
  alias Eye2eye.Orders.Order
  alias Eye2eye.Orders.LineItem

  describe "orders" do
    @invalid_order_attrs %{total_price: nil, user_uuid: nil}

    test "complete_order with valid data creates an order and empties the shopping cart" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)
      valid_order_attrs =  %{user_uuid: cart_with_one_item.user_uuid,
    total_price: ShoppingCart.total_cart_price(cart_with_one_item)}

      assert {:ok, %Order{} = order} = Orders.complete_order(cart_with_one_item, valid_order_attrs)

      assert order.total_price == Decimal.new("120.50")
      assert order.user_uuid == cart.user_uuid
    end

    test "complete_order with invalid order data returns error changeset" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)

      assert {:error, %Ecto.Changeset{}} = Orders.complete_order(cart_with_one_item, @invalid_order_attrs)
    end
  end
end
