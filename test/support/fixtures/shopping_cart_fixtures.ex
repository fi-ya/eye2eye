defmodule Eye2eye.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.ShoppingCart` context.
  """

  @doc """
  Generate a unique cart user_uuid.
  """
  def unique_cart_user_uuid do
    Ecto.UUID.generate()
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{
        user_uuid: Ecto.UUID.generate()
      })
      |> Eye2eye.ShoppingCart.create_cart()

    I0.inspect(cart)
    cart
  end

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> Eye2eye.ShoppingCart.create_cart_item()

    cart_item
  end
end
