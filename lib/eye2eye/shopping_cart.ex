defmodule Eye2eye.ShoppingCart do
  @moduledoc """
  The ShoppingCart context.
  """

  import Ecto.Query, warn: false

  alias Eye2eye.Repo
  alias Eye2eye.Catalog
  alias Eye2eye.ShoppingCart.{Cart, CartItem}

  @min_cart_item_price Decimal.new("0.00")

  @doc """
  Returns cart by user_uuid.

  Fetches our cart and joins the cart items,
  and their products so that we have the full cart
  populated with all preloaded data.

  """

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

  @doc """
  Creates a cart using user uuid.

  If insert successful reload cart contents

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  # ----- CART ITEMS FUNCTIONS START HERE -----

  @doc """
  Gets a single cart_item by id and add product
  associations to be preloaded into the result set.

  Raises `Ecto.NoResultsError` if the Cart item does
  not exist.

  ## Examples

      iex> get_cart_item!(123)
      %CartItem{}

      iex> get_cart_item!(456)
      ** (Ecto.NoResultsError)

  """

  def get_cart_item!(id) do
    Repo.one(
      from(i in CartItem,
        where: i.id == ^id,
        left_join: p in assoc(i, :product),
        preload: [product: p]
      )
    )
  end

  @doc """
  Adds an item to cart.

  Issue a Repo.insert call with a query to add a new cart item into the database,
  or increase the quantity by one if it already exists in the cart.

  """
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

  @doc """
  Validate cart_item_attrs then updates a cart_item and
  deletes if quantity is zero.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

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
end
