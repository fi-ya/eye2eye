defmodule Eye2eyeWeb.CartItemControllerTest do
  use Eye2eyeWeb.ConnCase

  alias Eye2eye.Catalog
  alias Eye2eye.ShoppingCart

  import Eye2eye.CatalogFixtures

  @invalid_attrs %{product_id: 2}

  describe "create a cart item" do
    test "redirects to product index route when data is valid, displays success message and cart counter",
         %{conn: conn} do
      product = create_product_fixture()

      conn = post(conn, Routes.cart_item_path(conn, :create), product_id: product.id)

      assert redirected_to(conn) == Routes.product_path(conn, :index)

      conn = get(conn, Routes.product_path(conn, :index))

      assert html_response(conn, 200) =~ "Item added to your cart"
      assert ShoppingCart.total_cart_items(conn.assigns.cart) == 1
    end
  end
end
