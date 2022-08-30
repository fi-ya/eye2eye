defmodule Eye2eye.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :quantity, :integer

    belongs_to :cart. Eye2eye.ShoppingCart.CartItem
    belongs_to :product, Eye2eye.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
