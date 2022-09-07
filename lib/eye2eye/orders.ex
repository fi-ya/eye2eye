defmodule Eye2eye.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false

  alias Eye2eye.Repo
  alias Eye2eye.ShoppingCart
  alias Eye2eye.Orders.Order
  alias Eye2eye.Orders.LineItem

  @doc """
  Creates a order.

  First by mapping the cart items of the shopping
  cart passed into a map of order line items structs
  which captures the product id, price and quantity.

  Then create an order changeset by passing in an empty
  Order changeset and our changes
  (user_uuid, total_price, line_items).

  Next the order is inserted and the run operation to
  prune the shopping cart

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

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
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} -> {:ok, order}
      {:error, :order, changeset, _changes_so_far} -> {:error, changeset}
    end
  end
end
