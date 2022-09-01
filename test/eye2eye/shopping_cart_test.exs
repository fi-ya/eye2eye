defmodule Eye2eye.ShoppingCartTest do
  use Eye2eye.DataCase

  alias Eye2eye.ShoppingCart
  alias Eye2eye.ShoppingCart.{CartItem, Cart}

  import Eye2eye.ShoppingCartFixtures

  describe "carts" do
    @valid_attrs %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @invalid_attrs %{user_uuid: nil}

    # test "list_carts/0 returns all carts" do
    #   cart = cart_fixture()
    #   assert ShoppingCart.list_carts() == [cart]
    # end

    # test "get_cart!/1 returns the cart with given id" do
    #   cart = cart_fixture()
    #   assert ShoppingCart.get_cart!(cart.id) == cart
    # end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(@valid_attrs.user_uuid)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs.user_uuid)
    end

    test "total_cart_items with valid data returns integer sum of item quantities" do
      {:ok, %Cart{} = cart} = ShoppingCart.create_cart(@valid_attrs.user_uuid)

      assert ShoppingCart.total_cart_items(cart) == 0
    end

    # test "update_cart/2 with valid data updates the cart" do
    #   cart = cart_fixture()
    #   update_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960668"}

    #   assert {:ok, %Cart{} = cart} = ShoppingCart.update_cart(cart, update_attrs)
    #   assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
    # end

    # test "update_cart/2 with invalid data returns error changeset" do
    #   cart = cart_fixture()
    #   assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart(cart, @invalid_attrs)
    #   assert cart == ShoppingCart.get_cart!(cart.id)
    # end

    # test "delete_cart/1 deletes the cart" do
    #   cart = cart_fixture()
    #   assert {:ok, %Cart{}} = ShoppingCart.delete_cart(cart)
    #   assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart!(cart.id) end
    # end

    # test "change_cart/1 returns a cart changeset" do
    #   cart = cart_fixture()
    #   assert %Ecto.Changeset{} = ShoppingCart.change_cart(cart)
    # end
  end

  describe "cart_items" do
    @invalid_attrs %{quantity: nil}

    test "list_cart_items/0 returns all cart_items" do
      cart_item = cart_item_fixture()
      assert ShoppingCart.list_cart_items() == [cart_item]
    end

    test "get_cart_item!/1 returns the cart_item with given id" do
      cart_item = cart_item_fixture()
      assert ShoppingCart.get_cart_item!(cart_item.id) == cart_item
    end

    test "create_cart_item/1 with valid data creates a cart_item" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %CartItem{} = cart_item} = ShoppingCart.create_cart_item(valid_attrs)
      assert cart_item.quantity == 42
    end

    test "create_cart_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart_item(@invalid_attrs)
    end

    test "update_cart_item/2 with valid data updates the cart_item" do
      cart_item = cart_item_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %CartItem{} = cart_item} =
               ShoppingCart.update_cart_item(cart_item, update_attrs)

      assert cart_item.quantity == 43
    end

    test "update_cart_item/2 with invalid quantity data returns error changeset" do
      cart_item = cart_item_fixture()
      update_attrs = %{quantity: 101}

      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart_item(cart_item, update_attrs)
      assert cart_item == ShoppingCart.get_cart_item!(cart_item.id)
      assert cart_item.quantity == 42
    end

    test "update_cart_item/2 with nil quantity data returns error changeset" do
      cart_item = cart_item_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ShoppingCart.update_cart_item(cart_item, @invalid_attrs)

      assert cart_item == ShoppingCart.get_cart_item!(cart_item.id)
    end

    test "delete_cart_item/1 deletes the cart_item" do
      cart_item = cart_item_fixture()
      assert {:ok, %CartItem{}} = ShoppingCart.delete_cart_item(cart_item)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart_item!(cart_item.id) end
    end

    test "change_cart_item/1 returns a cart_item changeset" do
      cart_item = cart_item_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart_item(cart_item)
    end
  end
end
