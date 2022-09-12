defmodule Eye2eyeWeb.OrderControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.CatalogFixtures
  import Eye2eye.OrdersFixtures

  alias Eye2eye.{ShoppingCart}
  alias Eye2eye.Orders

  @valid_cart_item_attrs %{quantity: 1}

  defp create_product(_) do
    product = create_product_fixture()
    %{product: product}
  end

  describe "index" do
    setup [:create_product]

    test "displays message when no orders present", %{conn: conn} do
      conn = get(conn, Routes.order_path(conn, :index))
      assert html_response(conn, 200) =~ "Your Orders"
      assert html_response(conn, 200) =~ "You have not placed any orders"
    end

    test "lists all orders when orders present", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :index))
      {:ok, _cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)
      conn = get(conn, Routes.cart_path(conn, :show))
      valid_order_params = %{
          user_uuid: conn.assigns.cart.user_uuid,
          total_price: Decimal.to_string(ShoppingCart.total_cart_price(conn.assigns.cart))
        }
      conn = post(conn, Routes.order_path(conn, :create, order: valid_order_params))

      conn = get(conn, Routes.order_path(conn, :index))

      assert html_response(conn, 200) =~ "Order ID"
      assert html_response(conn, 200) =~ "Order Date"
      assert html_response(conn, 200) =~ "Total Price"
      assert html_response(conn, 200) =~ "120.50"
      assert html_response(conn, 200) =~ "Show"
    end
  end

  describe "create order" do
    setup [:create_product]

    test "redirects to show empty cart message when order data is valid", %{
      conn: conn,
      product: product
    } do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, _cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      valid_order_params = %{
        user_uuid: conn.assigns.cart.user_uuid,
        total_price: Decimal.to_string(ShoppingCart.total_cart_price(conn.assigns.cart))
      }

      conn = post(conn, Routes.order_path(conn, :create, order: valid_order_params))
      assert %{id: id} = redirected_params(conn)

      order = Orders.get_order!(conn.assigns.current_uuid, id)
      assert redirected_to(conn) == Routes.order_path(conn, :show, order)

      conn = get(conn, Routes.order_path(conn, :show, order))

      assert html_response(conn, 200) =~ "Order created successfully."
      assert html_response(conn, 200) =~ "Order Summary"
      assert html_response(conn, 200) =~ "Product One"
      assert conn.assigns.cart.items == []
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, _cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      invalid_order_params = %{total_price: nil, user_uuid: conn.assigns.cart.user_uuid}

      conn = post(conn, Routes.order_path(conn, :create, order: invalid_order_params))

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "There was an error updating your cart"
      assert length(conn.assigns.cart.items) == 1
    end
  end
end
