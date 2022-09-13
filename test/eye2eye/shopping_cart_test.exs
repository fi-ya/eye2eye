defmodule Eye2eye.ShoppingCartTest do
  use Eye2eye.DataCase

  alias Eye2eye.ShoppingCart
  alias Eye2eye.ShoppingCart.Cart
  alias Eye2eye.ShoppingCart.CartItem

  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.CatalogFixtures

  @valid_cart_item_attrs %{quantity: 1}

  describe "carts" do
    @valid_attrs %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @invalid_attrs %{user_uuid: nil}
    @product_two_attrs %{
      name: "Product Two",
      image_url: "https://images.com/2",
      price: "100.00"
    }

    test "get_cart_by_user_uuid returns cart" do
      cart = create_cart_fixture()

      assert ShoppingCart.get_cart_by_user_uuid(cart.user_uuid) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(@valid_attrs.user_uuid)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs.user_uuid)
    end

    # test "total_cart_items when no cart items returns valid integer" do
    #   cart = create_cart_fixture()

    #   assert ShoppingCart.total_cart_items(cart) == 0
    # end

    # test "total_cart_items when one cart item returns valid integer" do
    #   product = create_product_fixture()
    #   cart = create_cart_fixture()
    #   cart_with_one_item = add_cart_item_fixture(cart, product)

    #   assert ShoppingCart.total_cart_items(cart_with_one_item) == 1
    # end

    # test "total_cart_items when one cart item with quantity two returns valid integer" do
    #   product_one = create_product_fixture()
    #   cart = create_cart_fixture()
    #   cart_with_item_q1 = add_cart_item_fixture(cart, product_one)
    #   cart_with_item_q2 = add_cart_item_fixture(cart_with_item_q1, product_one)

    #   assert ShoppingCart.total_cart_items(cart_with_item_q2) == 2
    # end

    # test "total_cart_items when two cart items with different quantities returns valid integer" do
    #   product_one = create_product_fixture()
    #   product_two = create_product_fixture(@product_two_attrs)
    #   cart = create_cart_fixture()
    #   cart_with_item_q1 = add_cart_item_fixture(cart, product_one)
    #   cart_with_item_q2 = add_cart_item_fixture(cart_with_item_q1, product_one)
    #   cart_with_item_q3 = add_cart_item_fixture(cart_with_item_q2, product_two)

    #   assert ShoppingCart.total_cart_items(cart_with_item_q3) == 3
    # end

    # test "total_cart_price when cart empty returns valid decimal" do
    #   cart = create_cart_fixture()

    #   assert ShoppingCart.total_cart_price(cart) === Decimal.new("0.00")
    # end

    # test "total_cart_price when cart has one item returns valid decimal" do
    #   product_one = create_product_fixture()
    #   cart = create_cart_fixture()
    #   cart_with_item_q1 = add_cart_item_fixture(cart, product_one)

    #   assert ShoppingCart.total_cart_price(cart_with_item_q1) === Decimal.new("120.50")
    # end

    # test "total_cart_price when cart has two items returns valid decimal" do
    #   product_one = create_product_fixture()
    #   product_two = create_product_fixture(@product_two_attrs)
    #   cart = create_cart_fixture()
    #   cart_with_item1 = add_cart_item_fixture(cart, product_one)
    #   cart_with_item2 = add_cart_item_fixture(cart_with_item1, product_two)

    #   assert ShoppingCart.total_cart_price(cart_with_item2) === Decimal.new("220.50")
    # end
  end

  describe "cart_items" do
    @invalid_cart_item_attrs %{quantity: 0}

    test "get_cart_item!/1 returns the cart_item with given id" do
      cart = create_cart_fixture()
      product = create_product_fixture()
      cart_with_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_item.items)

      assert ShoppingCart.get_cart_item!(cart_item.id) == cart_item
    end

    test "add_item_to_cart when cart is empty returns updated cart" do
      cart = create_cart_fixture()
      product = create_product_fixture()

      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item} =
               ShoppingCart.add_item_to_cart(cart, product, @valid_cart_item_attrs)

      reload_cart = ShoppingCart.reload_cart(cart)

      assert length(reload_cart.items) == 1
    end

    test "add_item_to_cart when cart already has one item returns updated cart" do
      cart = create_cart_fixture()
      product_one = create_product_fixture()
      product_two = create_product_fixture(@product_two_attrs)

      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item} =
               ShoppingCart.add_item_to_cart(cart, product_one, @valid_cart_item_attrs)

      cart_with_item_one = ShoppingCart.reload_cart(cart)

      assert {:ok, %CartItem{} = _cart} =
               ShoppingCart.add_item_to_cart(
                 cart_with_item_one,
                 product_two,
                 @valid_cart_item_attrs
               )

      cart_with_item_two = ShoppingCart.reload_cart(cart_with_item_one)

      assert length(cart_with_item_two.items) == 2
    end

    test "add_item_to_cart when cart has the item already returns no increase in length" do
      cart = create_cart_fixture()
      _product_one = create_product_fixture()
      product_one = create_product_fixture()

      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item_one} =
               ShoppingCart.add_item_to_cart(cart, product_one, @valid_cart_item_attrs)

      cart_with_item_q1 = ShoppingCart.reload_cart(cart)

      assert {:ok, %CartItem{} = _cart_item_two} =
               ShoppingCart.add_item_to_cart(
                 cart_with_item_q1,
                 product_one,
                 @valid_cart_item_attrs
               )

      cart_with_item_q2 = ShoppingCart.reload_cart(cart_with_item_q1)

      assert length(cart_with_item_q2.items) == 1
    end

    # test "total_item_price where one cart item present with quantity one returns valid decimal" do
    #   product = create_product_fixture()
    #   cart = create_cart_fixture()
    #   cart_with_one_item = add_cart_item_fixture(cart, product)
    #   cart_item = List.first(cart_with_one_item.items)

    #   assert cart_item.product.price === Decimal.new("120.50")
    #   assert cart_item.quantity === 1
    #   assert ShoppingCart.total_item_price(cart_item) === Decimal.new("120.50")
    # end

    # test "total_item_price where one cart item present with quantity two returns valid decimal" do
    #   product_one = create_product_fixture()
    #   cart = create_cart_fixture()
    #   _cart_with_one_item_q1 = add_cart_item_fixture(cart, product_one)
    #   cart_with_one_item_q2 = add_cart_item_fixture(cart, product_one)
    #   cart_item = List.first(cart_with_one_item_q2.items)

    #   assert cart_item.product.price === Decimal.new("120.50")
    #   assert cart_item.quantity === 2
    #   assert ShoppingCart.total_item_price(cart_item) === Decimal.new("241.00")
    # end

    test "update_cart_item where one item with one quantity returns updated cart without item" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)
      cart_item_attrs = %{quantity: cart_item.quantity}

      assert length(cart_with_one_item.items) == 1
      assert cart_item.quantity == 1

      assert {:ok, %CartItem{} = updated_cart_item} =
               ShoppingCart.update_cart_item(cart_item, cart_item_attrs)

      assert updated_cart_item.quantity == 0

      updated_cart = ShoppingCart.reload_cart(cart_with_one_item)
      assert Enum.empty?(updated_cart.items)
    end

    test "update_cart_item where one item with two quantity returns updated cart quantity" do
      product_one = create_product_fixture()
      cart = create_cart_fixture()
      _cart_with_one_item_q1 = add_cart_item_fixture(cart, product_one)
      cart_with_one_item_q2 = add_cart_item_fixture(cart, product_one)
      cart_item = List.first(cart_with_one_item_q2.items)
      cart_item_attrs = %{quantity: cart_item.quantity}

      assert cart_item.quantity == 2

      assert {:ok, %CartItem{} = updated_cart_item} =
               ShoppingCart.update_cart_item(cart_item, cart_item_attrs)

      assert updated_cart_item.quantity == 1
    end

    test "update_cart_item with invalid cart item quantity data returns error changeset" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)

      assert {:error, %Ecto.Changeset{}} =
               ShoppingCart.update_cart_item(cart_item, @invalid_cart_item_attrs)

      assert cart_item.quantity == 1
    end

    test "reduce_item_quantity_by_one where quantity is one returns correct integer" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)

      assert cart_item.quantity == 1
      assert ShoppingCart.reduce_item_quantity_by_one(cart_item).quantity == 0
      assert Map.has_key?(ShoppingCart.reduce_item_quantity_by_one(cart_item), :quantity)
    end

    test "reduce_item_quantity_by_one where quantity is two returns correct integer" do
      product_one = create_product_fixture()
      cart = create_cart_fixture()
      _cart_with_one_item_q1 = add_cart_item_fixture(cart, product_one)
      cart_with_one_item_q2 = add_cart_item_fixture(cart, product_one)
      cart_item = List.first(cart_with_one_item_q2.items)

      assert cart_item.quantity == 2
      assert ShoppingCart.reduce_item_quantity_by_one(cart_item).quantity == 1
    end

    test "prune_cart_items returns an empty cart" do
      product = create_product_fixture()
      cart = create_cart_fixture()
      cart_with_one_item = add_cart_item_fixture(cart, product)

      assert {:ok, %Cart{} = cart} = ShoppingCart.prune_cart_items(cart_with_one_item)
      assert cart.items == []
    end
  end
end
