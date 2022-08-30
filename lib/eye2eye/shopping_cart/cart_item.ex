defmodule Eye2eye.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :quantity, :integer
    field :cart_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
