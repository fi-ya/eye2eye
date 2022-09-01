defmodule Eye2eyeWeb.ProductController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.{ShoppingCart, Catalog}

  def index(conn, _params) do
    products = Catalog.list_products()
    total_cart_items = ShoppingCart.total_cart_items(conn.assigns.cart)

    render(conn, "index.html", products: products, total_cart_items: total_cart_items)
  end
end
