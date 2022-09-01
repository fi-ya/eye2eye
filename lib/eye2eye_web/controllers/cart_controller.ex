defmodule Eye2eyeWeb.CartController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.ShoppingCart

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
