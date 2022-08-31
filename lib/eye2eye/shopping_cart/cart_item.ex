defmodule Eye2eye.ShoppingCart.CartItem do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :quantity, :integer

    belongs_to :cart, Eye2eye.ShoppingCart.Cart
    belongs_to :product, Eye2eye.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0, less_than: 100)
  end
end
