defmodule Eye2eye.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :image_url, :string
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :image_url, :price])
    |> validate_required([:name, :image_url, :price])
  end
end
