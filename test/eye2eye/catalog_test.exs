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

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        image_url: "https://images.unsplash.com/photo",
        name: "some name",
        price: "120.50",
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.image_url == "https://images.unsplash.com/photo"
      assert product.name == "some name"
      assert product.price == Decimal.new("120.50")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        image_url: "https://images.unsplash.com/photo2",
        name: "some updated name",
        price: "456.70",
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.image_url == "https://images.unsplash.com/photo2"
      assert product.name == "some updated name"
      assert product.price == Decimal.new("456.70")
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
