defmodule Eye2eye.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eye2eye.Catalog` context.
  """
  @product_one_attrs %{
    name: "Product One",
    image_url: "https://images.com/1",
    price: "120.50"
  }

  def create_product_fixture(attrs \\ %{}, product_attrs \\ @product_one_attrs) do
    {:ok, product} =
      attrs
      |> Enum.into(product_attrs)
      |> Eye2eye.Catalog.create_product()

    product
  end
end
