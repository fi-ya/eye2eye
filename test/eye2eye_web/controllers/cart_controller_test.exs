defmodule Eye2eyeWeb.CartControllerTest do
  use Eye2eyeWeb.ConnCase

  alias Eye2eye.Catalog
  alias Eye2eye.{ShoppingCart, Catalog}

  import Eye2eye.CatalogFixtures

  describe "show" do
    test "display message when cart empty", %{conn: conn} do
      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "Your cart is empty"
    end

    test "display cart item when there is an item in the cart", %{conn: conn} do
      product = create_product_fixture()

      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, add_to_cart} = ShoppingCart.add_item_to_cart(conn.assigns.cart, product)
      conn = assign(conn, :cart, add_to_cart)

      conn = get(conn, Routes.cart_path(conn, :show))
      conn = assign(conn, :cart, add_to_cart)

      assert html_response(conn, 200) =~ "Product One"
      assert html_response(conn, 200) =~ "https://images.com/1"
      assert html_response(conn, 200) =~ "120.50"
    end
  end
end
