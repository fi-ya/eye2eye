defmodule Eye2eyeWeb.OrderController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.Orders
  alias Eye2eye.Orders.Order
  alias Eye2eye.{ShoppingCart, Catalog}

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
