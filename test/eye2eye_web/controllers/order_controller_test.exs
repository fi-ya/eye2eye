defmodule Eye2eyeWeb.OrderControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.CatalogFixtures
  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.OrdersFixtures

  alias Eye2eye.{ShoppingCart, Catalog}

  @valid_cart_item_attrs %{quantity: 1}

  describe "create order" do
    test "redirects to show empty cart message when order data is valid", %{conn: conn} do
      product = create_product_fixture()
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      valid_order_params = %{
        user_uuid: conn.assigns.cart.user_uuid,
        total_price: Decimal.to_string(ShoppingCart.total_cart_price(conn.assigns.cart))
      }

      conn = post(conn, Routes.order_path(conn, :create, order: valid_order_params))

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "Order created successfully."
      assert html_response(conn, 200) =~ "Your cart is empty"
      assert html_response(conn, 200) != "Product One"
      assert conn.assigns.cart.items == []
    end

    test "renders errors when data is invalid", %{conn: conn} do
      product = create_product_fixture()
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      invalid_order_params = %{total_price: nil, user_uuid: conn.assigns.cart.user_uuid}

      conn = post(conn, Routes.order_path(conn, :create, order: invalid_order_params))

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "There was an error updating your cart"
    end
  end
end