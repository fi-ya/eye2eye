defmodule Eye2eye.ShoppingCart do
  @moduledoc """
  The ShoppingCart context.
  """

  import Ecto.Query, warn: false

  alias Eye2eye.Repo
  alias Eye2eye.Catalog
  alias Eye2eye.ShoppingCart.{Cart, CartItem}

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

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def update_cart(%Cart{} = cart, attrs) do
  #   cart
  #   |> Cart.changeset(attrs)
  #   |> Repo.update()
  # end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """

  # def delete_cart(%Cart{} = cart) do
  #   Repo.delete(cart)
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """

  # def change_cart(%Cart{} = cart, attrs \\ %{}) do
  #   Cart.changeset(cart, attrs)
  # end

  def total_cart_items(%Cart{} = cart) do
    Enum.reduce(cart.items, 0, fn item, acc ->
      item.quantity + acc
    end)
  end

  def total_cart_price(%Cart{} = cart) do
    Enum.reduce(cart.items, Decimal.new("0.00"), fn item, acc ->
      item
      |> total_item_price()
      |> Decimal.add(acc)
    end)
  end

  # ----- CART ITEMS FUNCTIONS START HERE -----

  @doc """
  Returns the list of cart_items.

  ## Examples

      iex> list_cart_items()
      [%CartItem{}, ...]

  """

  # def list_cart_items do
  #   Repo.all(CartItem)
  # end

  @doc """
  Gets a single cart_item.

  Raises `Ecto.NoResultsError` if the Cart item does not exist.

  ## Examples

      iex> get_cart_item!(123)
      %CartItem{}

      iex> get_cart_item!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_cart_item!(id), do: Repo.get!(CartItem, id)

  @doc """
  Adds an item to cart.

  Issue a Repo.insert call with a query to add a new cart item into the database,
  or increase the quantity by one if it already exists in the cart.

  """
  def add_item_to_cart(%Cart{} = cart, %Catalog.Product{} = product) do
    %CartItem{quantity: 1}
    |> CartItem.changeset(%{})
    |> Ecto.Changeset.put_assoc(:cart, cart)
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert(
      on_conflict: [inc: [quantity: 1]],
      conflict_target: [:cart_id, :product_id]
    )

    {:ok, reload_cart(cart)}
  end

  def total_item_price(%CartItem{} = item) do
    Decimal.mult(item.product.price, item.quantity)
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def update_cart_item(%CartItem{} = cart_item, attrs) do
  #   cart_item
  #   |> CartItem.changeset(attrs)
  #   |> Repo.update()
  # end

  @doc """
  Deletes a cart_item.

  ## Examples

      iex> delete_cart_item(cart_item)
      {:ok, %CartItem{}}

      iex> delete_cart_item(cart_item)
      {:error, %Ecto.Changeset{}}

  """

  # def delete_cart_item(%CartItem{} = cart_item) do
  #   Repo.delete(cart_item)
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart_item changes.

  ## Examples

      iex> change_cart_item(cart_item)
      %Ecto.Changeset{data: %CartItem{}}

  """
  # def change_cart_item(%CartItem{} = cart_item, attrs \\ %{}) do
  #   CartItem.changeset(cart_item, attrs)
  # end
end
