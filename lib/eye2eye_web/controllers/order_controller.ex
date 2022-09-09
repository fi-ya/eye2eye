defmodule Eye2eyeWeb.OrderController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.Orders

  def index(conn, _params) do
    orders = Orders.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    case Orders.complete_order(conn.assigns.cart, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: Routes.cart_path(conn, :show))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error updating your cart")
        |> redirect(to: Routes.cart_path(conn, :show))
    end
  end
end
