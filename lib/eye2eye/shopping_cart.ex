defmodule Eye2eye.ShoppingCart do
  @moduledoc """
  The ShoppingCart context.
  """

  import Ecto.Query, warn: false

  alias Eye2eye.Repo
  alias Eye2eye.Catalog
  alias Eye2eye.ShoppingCart.{Cart, CartItem}

  @min_cart_item_price Decimal.new("0.00")

  def get_cart_by_user_uuid(user_uuid) do
    Repo.one(
      from(c in Cart,
        where: c.user_uuid == ^user_uuid,
        left_join: i in assoc(c, :items),
        left_join: p in assoc(i, :product),
        order_by: [asc: i.inserted_at],
        preload: [items: {i, product: p}]
      )
    )
  end

  def create_cart(user_uuid) do
    %Cart{user_uuid: user_uuid}
    |> Cart.changeset(%{})
    |> Repo.insert()
    |> case do
      {:ok, cart} -> {:ok, reload_cart(cart)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def reload_cart(%Cart{} = cart), do: get_cart_by_user_uuid(cart.user_uuid)

  def total_cart_items(%Cart{} = cart) do
    Enum.reduce(cart.items, 0, fn item, acc ->
      item.quantity + acc
    end)
  end

  def total_cart_price(%Cart{} = cart) do
    Enum.reduce(cart.items, @min_cart_item_price, fn item, acc ->
      item
      |> total_item_price()
      |> Decimal.add(acc)
    end)
  end

  def get_cart_item!(id) do
    Repo.one(
      from(i in CartItem,
        where: i.id == ^id,
        left_join: p in assoc(i, :product),
        preload: [product: p]
      )
    )
  end

  def add_item_to_cart(%Cart{} = cart, %Catalog.Product{} = product, cart_item_attrs) do
    %CartItem{}
    |> CartItem.changeset(cart_item_attrs)
    |> Ecto.Changeset.put_assoc(:cart, cart)
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert(
      on_conflict: [inc: [quantity: 1]],
      conflict_target: [:cart_id, :product_id]
    )
  end

  def total_item_price(%CartItem{} = item) do
    Decimal.mult(item.product.price, item.quantity)
  end

  def update_cart_item(%CartItem{} = cart_item, cart_item_attrs) do
    update_attrs = reduce_item_quantity_by_one(cart_item_attrs)

    changeset =
      cart_item
      |> CartItem.changeset(update_attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:cart_item, changeset)
    |> Ecto.Multi.delete_all(:discarded_items, fn %{cart_item: cart_item} ->
      from(i in CartItem, where: i.quantity == 0)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{cart_item: cart_item}} -> {:ok, cart_item}
      {:error, :cart_item, changeset, _changes_so_far} -> {:error, changeset}
    end
  end

  def reduce_item_quantity_by_one(cart_item_attrs, updated_attrs \\ %{}) do
    updated_quantity = cart_item_attrs.quantity - 1

    updated_attrs
    |> Enum.into(%{quantity: updated_quantity})
  end

  def prune_cart_items(%Cart{} = cart) do
    {_, _} = Repo.delete_all(from(i in CartItem, where: i.cart_id == ^cart.id))
    {:ok, reload_cart(cart)}
  end
end
