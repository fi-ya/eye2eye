defmodule Eye2eyeWeb.OrderControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.CatalogFixtures
  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.OrdersFixtures

  alias Eye2eye.{ShoppingCart, Catalog}

  @valid_cart_item_attrs %{quantity: 1}

  describe "create order" do

    test "redirects to show empty cart message when order data is valid", %{conn: conn} do
      # create product
      product = create_product_fixture()
      conn = get(conn, Routes.product_path(conn, :index))

      # add product to cart
      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)
      IO.puts("CREATE CART ITEM after add: " <> inspect(cart_item))
      IO.puts("CREATE CART after: " <> inspect(conn.assigns.cart))

      # redirect to cart
      conn = get(conn, Routes.cart_path(conn, :show))
      IO.puts("CREATE CART reload: " <> inspect(conn.assigns.cart))

      # click checkout - pass in cart id and attrs
      valid_order_attrs =  %{
        user_uuid: conn.assigns.cart.user_uuid,
        total_price: Decimal.to_string(ShoppingCart.total_cart_price(conn.assigns.cart))
      }
      IO.puts("CREATE CART valid_order_attrs: " <> inspect(valid_order_attrs))

      conn = post(conn, Routes.order_path(conn, :create, order_attrs: valid_order_attrs))

      # # assert redirected
      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      # # get /cart
      conn = get(conn, Routes.cart_path(conn, :show))
      IO.puts("CREATE CART htmk: " <> inspect(html_response(conn, 200)))
      # # assert cart is empty
      assert html_response(conn, 200) =~ "Order created successfully."
      assert html_response(conn, 200) =~ "Your cart is empty"
      assert html_response(conn, 200) != "Product One"
      assert conn.assigns.cart.items == []
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # create product
      product = create_product_fixture()
      conn = get(conn, Routes.product_path(conn, :index))

      # add product to cart
      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)
      IO.puts("F CREATE CART ITEM after add: " <> inspect(cart_item))
      IO.puts("F CREATE CART after: " <> inspect(conn.assigns.cart))

      # redirect to cart
      conn = get(conn, Routes.cart_path(conn, :show))
      IO.puts("F CREATE CART reload: " <> inspect(conn.assigns.cart))

      invalid_order_attrs = %{total_price: nil , user_uuid: conn.assigns.cart.user_uuid}

      conn = post(conn, Routes.order_path(conn, :create, order_attrs: invalid_order_attrs))

      # # assert redirected
      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      # # get /cart
      conn = get(conn, Routes.cart_path(conn, :show))
      IO.puts("F CREATE CART htmk: " <> inspect(html_response(conn, 200)))
      # # assert cart is empty
      assert html_response(conn, 200) =~ "There was an error updating your cart"
   end
  end
end
