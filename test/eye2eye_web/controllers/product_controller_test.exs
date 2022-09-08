defmodule Eye2eyeWeb.ProductControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.CatalogFixtures

  defp create_product(_) do
    product = create_product_fixture()
    %{product: product}
  end

  describe "index" do
    setup [:create_product]

    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))

      assert html_response(conn, 200) =~ "Summer 2022 Collection"
      assert html_response(conn, 200) =~ "Product One"
      assert html_response(conn, 200) =~ "https://images.com/1"
      assert html_response(conn, 200) =~ "120.50"
      assert html_response(conn, 200) =~ "Add to cart"
    end
  end
end
