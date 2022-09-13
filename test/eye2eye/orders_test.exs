defmodule Eye2eye.OrdersTest do
  use Eye2eye.DataCase

  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.CatalogFixtures
  import Eye2eye.OrdersFixtures

  alias Eye2eye.ShoppingCart
  alias Eye2eye.Orders
  alias Eye2eye.Orders.Order
  alias Eye2eyeWeb.CartView

  defp create_cart_with_item(_) do
    product = create_product_fixture()
    cart = create_cart_fixture()
    cart_with_one_item = add_cart_item_fixture(cart, product)
    %{cart_with_one_item: cart_with_one_item}
  end

  describe "orders" do
    setup [:create_cart_with_item]

    @invalid_order_attrs %{total_price: nil, user_uuid: nil}

    test "list_orders/0 returns all orders", %{cart_with_one_item: cart_with_one_item} do
      order = order_fixture(cart_with_one_item)

      assert Orders.list_orders() == [order]
    end

    test "get_order/2 returns the order with given user_uuid", %{
      cart_with_one_item: cart_with_one_item
    } do
      order = order_fixture(cart_with_one_item)

      assert Orders.get_order!(cart_with_one_item.user_uuid, order.id).id == order.id
    end

    test "complete_order/2 with valid data creates an order and empties the shopping cart", %{
      cart_with_one_item: cart_with_one_item
    } do
      valid_order_attrs = %{
        user_uuid: cart_with_one_item.user_uuid,
        total_price: CartView.total_cart_price(cart_with_one_item)
      }

      assert {:ok, %Order{} = order} =
               Orders.complete_order(cart_with_one_item, valid_order_attrs)

      assert order.total_price == Decimal.new("120.50")
      assert order.user_uuid == cart_with_one_item.user_uuid

      reload_cart = ShoppingCart.get_cart_by_user_uuid(cart_with_one_item.user_uuid)

      assert reload_cart.items == []
    end

    test "complete_order/2 with invalid order data returns error changeset", %{
      cart_with_one_item: cart_with_one_item
    } do
      assert {:error, %Ecto.Changeset{}} =
               Orders.complete_order(cart_with_one_item, @invalid_order_attrs)
    end
  end
end
