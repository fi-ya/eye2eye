defmodule Eye2eyeWeb.CartController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.ShoppingCart

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def update(conn, %{"item_id" => item_id, "cart_item_attrs" => cart_item_attrs}) do
    cart_item = ShoppingCart.get_cart_item!(item_id)
    attrs = %{quantity: String.to_integer(cart_item_attrs["quantity"])}

    case ShoppingCart.update_cart_item(cart_item, attrs) do
      {:ok, cart_item} ->
        conn
        |> redirect(to: Routes.cart_path(conn, :show))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error updating your cart")
        |> redirect(to: Routes.cart_path(conn, :show))
    end
  end
end
