defmodule Eye2eye.CatalogTest do
  use Eye2eye.DataCase

  alias Eye2eye.Catalog

  describe "products" do
    alias Eye2eye.Catalog.Product

    import Eye2eye.CatalogFixtures

    @invalid_attrs %{image_url: nil, name: nil, price: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        image_url: "https://images.unsplash.com/photo",
        name: "some name",
        price: "120.50"
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.image_url == "https://images.unsplash.com/photo"
      assert product.name == "some name"
      assert product.price == Decimal.new("120.50")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end
  end
end
