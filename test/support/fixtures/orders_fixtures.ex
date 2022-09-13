defmodule Eye2eye.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.Orders` context.
  """

  alias Eye2eyeWeb.CartView

  @doc """
  Generates an order

  """

  def order_fixture(cart, attrs \\ %{}) do
    attrs = %{
      user_uuid: cart.user_uuid,
      total_price: CartView.total_cart_price(cart)
    }

    {:ok, order} = Eye2eye.Orders.complete_order(cart, attrs)
    order
  end
end
