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
        user_uuid: unique_cart_user_uuid()
      })
      |> Eye2eye.ShoppingCart.create_cart()

    cart
  end
end
