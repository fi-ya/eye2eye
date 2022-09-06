defmodule Eye2eyeWeb.CartItemController do
  use Eye2eyeWeb, :controller

  alias Eye2eye.{ShoppingCart, Catalog}

  def create(conn, %{"product_id" => product_id, "cart_item_attrs" => cart_item_attrs}) do
    product = Catalog.get_product!(product_id)
    attrs = %{quantity: String.to_integer(cart_item_attrs["quantity"])}

    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product, attrs) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item added to your cart")
        |> redirect(to: Routes.product_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error adding the item to your cart")
        |> redirect(to: Routes.product_path(conn, :index))
    end
  end
end
