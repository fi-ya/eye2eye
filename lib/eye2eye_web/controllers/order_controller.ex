defmodule Eye2eyeWeb.OrderController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.Orders
  alias Eye2eye.Orders.Order
  alias Eye2eye.{ShoppingCart, Catalog}

  def create(conn, %{"order_attrs"=> order_attrs}) do
    IO.puts("CREATE order_attrs "<> inspect(order_attrs))

    attrs = %{
      user_uuid: order_attrs["user_uuid"],
      total_price: order_attrs["total_price"]
    }

    IO.puts("CREATE attrs "<> inspect(order_attrs))
    IO.puts("CREATE CART assigns "<> inspect(conn.assigns.cart))

    case Orders.complete_order(conn.assigns.cart, order_attrs) do
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
