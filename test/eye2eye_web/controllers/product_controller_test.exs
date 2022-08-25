defmodule Eye2eyeWeb.ProductControllerTest do
  use Eye2eyeWeb.ConnCase

  alias Eye2eye.Catalog

  import Eye2eye.CatalogFixtures

  describe "index" do
    test "lists all ", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert html_response(conn, 200) =~ "Summer 2022 Collection"
    end
  end

end
