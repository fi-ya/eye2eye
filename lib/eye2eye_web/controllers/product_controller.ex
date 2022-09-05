defmodule Eye2eyeWeb.ProductController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.{ShoppingCart, Catalog}

  def index(conn, _params) do
    products = Catalog.list_products()

    render(conn, "index.html", products: products)
  end
end
