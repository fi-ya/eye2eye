defmodule Eye2eyeWeb.ProductControllerTest do
  use Eye2eyeWeb.ConnCase

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert html_response(conn, 200) =~ "Summer 2022 Collection"
    end
  end
end
