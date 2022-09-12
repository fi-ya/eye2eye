defmodule Eye2eye.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false

  alias Eye2eye.Repo
  alias Eye2eye.ShoppingCart
  alias Eye2eye.Orders.Order

  def list_orders() do
    Repo.all(from(o in Order, order_by: [desc: o.inserted_at], preload: :line_items))
  end

  def get_order!(user_uuid, id) do
    Order
    |> Repo.get_by!(id: id, user_uuid: user_uuid)
    |> Repo.preload(line_items: [:product])
  end

  def complete_order(%ShoppingCart.Cart{} = cart, order_attrs) do
    line_items =
      Enum.map(cart.items, fn item ->
        %{product_id: item.product_id, price: item.product.price, quantity: item.quantity}
      end)

    order_changeset =
      %Order{}
      |> Order.changeset(order_attrs)
      |> Ecto.Changeset.change(line_items: line_items)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:order, order_changeset)
    |> Ecto.Multi.run(:prune_cart, fn _repo, _changes ->
      ShoppingCart.prune_cart_items(cart)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} -> {:ok, order}
      {:error, :order, order_changeset, _changes_so_far} -> {:error, order_changeset}
    end
  end
end
