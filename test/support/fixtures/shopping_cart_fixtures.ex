defmodule Eye2eye.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.ShoppingCart` context.

  @doc \"""
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

  def add_cart_item_fixture(cart, product) do
    {:ok, cart_with_item} = Eye2eye.ShoppingCart.add_item_to_cart(cart, product)
    cart_with_item
  end

  def reload_cart_fixture(user_uuid) do
    {:ok, reload_cart} = Eye2eye.ShoppingCart.get_cart_by_user_uuid(user_uuid)

    reload_cart
  end
end
