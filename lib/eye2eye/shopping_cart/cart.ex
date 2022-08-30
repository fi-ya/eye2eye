defmodule Eye2eye.ShoppingCart.Cart do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    field :user_uuid, Ecto.UUID

    has_many :items, Eye2eye.ShoppingCart.CartItem

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_uuid])
    |> validate_required([:user_uuid])
    |> unique_constraint(:user_uuid)
  end
end
