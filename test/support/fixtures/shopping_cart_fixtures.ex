defmodule Eye2eye.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.ShoppingCart` context.
  """
  @valid_cart_item_attrs %{quantity: 1}

  @doc """
  Generate a unique cart user_uuid.
  """
  def unique_cart_user_uuid do
    Ecto.UUID.generate()
  end

  @doc """
  Generate a cart.
  """

  def create_cart_fixture() do
    {:ok, cart} = Eye2eye.ShoppingCart.create_cart(unique_cart_user_uuid())
    cart
  end

  def add_cart_item_fixture(cart, product, attrs \\ @valid_cart_item_attrs) do
    {:ok, cart_with_item} = Eye2eye.ShoppingCart.add_item_to_cart(cart, product, attrs)
    {:ok, reload_cart = Eye2eye.ShoppingCart.reload_cart(cart)}
    reload_cart
  end
end
