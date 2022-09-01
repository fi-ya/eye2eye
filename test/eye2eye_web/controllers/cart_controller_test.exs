defmodule Eye2eyeWeb.CartControllerTest do
  use Eye2eyeWeb.ConnCase

  describe "show" do
    test "display message when cart empty", %{conn: conn} do
      conn = get(conn, Routes.cart_path(conn, :show))
      assert html_response(conn, 200) =~ "Your cart is empty"
    end
  end
end
