defmodule Eye2eye.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        total_price: "120.50",
        user_uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Eye2eye.Orders.create_order()

    order
  end
end
