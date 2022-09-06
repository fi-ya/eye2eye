defmodule Eye2eyeWeb.CartItemControllerTest do
  use Eye2eyeWeb.ConnCase

  alias Eye2eye.Catalog
  alias Eye2eye.ShoppingCart

  import Eye2eye.CatalogFixtures

  @invalid_cart_item_attrs %{quantity: 150}
  @valid_cart_item_attrs %{quantity: 1}

  describe "create a cart item" do
    test "redirects to product index route when cart item data is valid with success message",
         %{conn: conn} do
      product = create_product_fixture()

      conn =
        post(
          conn,
          Routes.cart_item_path(conn, :create,
            product_id: product.id,
            cart_item_attrs: @valid_cart_item_attrs
          )
        )

      assert redirected_to(conn) == Routes.product_path(conn, :index)

      conn = get(conn, Routes.product_path(conn, :index))

      assert html_response(conn, 200) =~ "Item added to your cart"
      assert length(conn.assigns.cart.items) == 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      product = create_product_fixture()

      conn =
        post(
          conn,
          Routes.cart_item_path(conn, :create,
            product_id: product.id,
            cart_item_attrs: @invalid_cart_item_attrs
          )
        )

      assert redirected_to(conn) == Routes.product_path(conn, :index)

      conn = get(conn, Routes.product_path(conn, :index))

      assert html_response(conn, 200) =~ "There was an error adding the item to your cart"
    end
  end
end
