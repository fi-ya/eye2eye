defmodule Eye2eyeWeb.CartItemControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.ShoppingCartFixtures

  @create_attrs %{quantity: 1}
  @invalid_attrs %{quantity: nil}

  describe "create a cart item" do
    test "redirects to product index route when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.product_path(conn, :index, id)

      conn = get(conn, Routes.product_path(conn, :index, id))
      assert html_response(conn, 200) =~ "Summer Collection"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert html_response(conn, 200) =~ "Summer Collection"
    end
  end
end
