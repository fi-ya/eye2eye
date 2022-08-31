defmodule Eye2eyeWeb.CartItemControllerTest do
  use Eye2eyeWeb.ConnCase

  # import Eye2eye.ShoppingCartFixtures

  # @create_attrs %{product_id: 1}
  # @invalid_attrs %{product_id: nil}

  describe "create a cart item" do
    # test "redirects to product index route when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.cart_item_path(conn, :create), product_id: @create_attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.product_path(conn, :index, id)

    #   conn = get(conn, Routes.product_path(conn, :index, id))
    #   assert html_response(conn, 200) =~ "Item added to your cart"
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.cart_item_path(conn, :create), product: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "There was an error adding the item to your cart"
    # end
  end
end
