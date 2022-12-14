defmodule Eye2eye.ShoppingCartTest do
  use Eye2eye.DataCase

  alias Eye2eye.ShoppingCart
  alias Eye2eye.ShoppingCart.Cart
  alias Eye2eye.ShoppingCart.CartItem

  import Eye2eye.ShoppingCartFixtures
  import Eye2eye.CatalogFixtures

  defp create_product(_) do
    product = create_product_fixture()
    %{product: product}
  end

  defp create_cart(_) do
    cart = create_cart_fixture()
    %{cart: cart}
  end

  @valid_cart_item_attrs %{quantity: 1}

  describe "carts" do
    setup [:create_cart]

    @valid_attrs %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @invalid_attrs %{user_uuid: nil}

    test "get_cart_by_user_uuid/1 returns cart", %{cart: cart} do
      assert ShoppingCart.get_cart_by_user_uuid(cart.user_uuid) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(@valid_attrs.user_uuid)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs.user_uuid)
    end
  end

  describe "cart_items" do
    setup [:create_product, :create_cart]

    @invalid_cart_item_attrs %{quantity: 0}
    @product_two_attrs %{
      name: "Product Two",
      image_url: "https://images.com/2",
      price: "100.00"
    }

    test "get_cart_item!/1 returns the cart_item with given id", %{cart: cart, product: product} do
      cart_with_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_item.items)

      assert ShoppingCart.get_cart_item!(cart_item.id) == cart_item
    end

    test "add_item_to_cart/3 when cart is empty returns updated cart", %{
      cart: cart,
      product: product
    } do
      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item} =
               ShoppingCart.add_item_to_cart(cart, product, @valid_cart_item_attrs)

      reload_cart = ShoppingCart.reload_cart(cart)

      assert length(reload_cart.items) == 1
    end

    test "add_item_to_cart/3 when cart already has one item returns updated cart", %{
      cart: cart,
      product: product
    } do
      product_two = create_product_fixture(@product_two_attrs)

      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item} =
               ShoppingCart.add_item_to_cart(cart, product, @valid_cart_item_attrs)

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

    test "add_item_to_cart/3 when cart has the item already returns no increase in length", %{
      cart: cart,
      product: product
    } do
      assert cart.items == []

      assert {:ok, %CartItem{} = _cart_item_one} =
               ShoppingCart.add_item_to_cart(cart, product, @valid_cart_item_attrs)

      cart_with_item_q1 = ShoppingCart.reload_cart(cart)

      assert {:ok, %CartItem{} = _cart_item_two} =
               ShoppingCart.add_item_to_cart(
                 cart_with_item_q1,
                 product,
                 @valid_cart_item_attrs
               )

      cart_with_item_q2 = ShoppingCart.reload_cart(cart_with_item_q1)

      assert length(cart_with_item_q2.items) == 1
    end

    test "update_cart_item/2 where one item with one quantity returns updated cart without item",
         %{cart: cart, product: product} do
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

    test "update_cart_item/2 where one item with two quantity returns updated cart quantity", %{
      cart: cart,
      product: product
    } do
      _cart_with_one_item_q1 = add_cart_item_fixture(cart, product)
      cart_with_one_item_q2 = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item_q2.items)
      cart_item_attrs = %{quantity: cart_item.quantity}

      assert cart_item.quantity == 2

      assert {:ok, %CartItem{} = updated_cart_item} =
               ShoppingCart.update_cart_item(cart_item, cart_item_attrs)

      assert updated_cart_item.quantity == 1
    end

    test "update_cart_item/2 with invalid cart item quantity data returns error changeset", %{
      cart: cart,
      product: product
    } do
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)

      assert {:error, %Ecto.Changeset{}} =
               ShoppingCart.update_cart_item(cart_item, @invalid_cart_item_attrs)

      assert cart_item.quantity == 1
    end

    test "reduce_item_quantity_by_one/1 where quantity is one returns correct integer", %{
      cart: cart,
      product: product
    } do
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)

      assert cart_item.quantity == 1
      assert ShoppingCart.reduce_item_quantity_by_one(cart_item).quantity == 0
      assert Map.has_key?(ShoppingCart.reduce_item_quantity_by_one(cart_item), :quantity)
    end

    test "reduce_item_quantity_by_one/1 where quantity is two returns correct integer", %{
      cart: cart,
      product: product
    } do
      _cart_with_one_item_q1 = add_cart_item_fixture(cart, product)
      cart_with_one_item_q2 = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item_q2.items)

      assert cart_item.quantity == 2
      assert ShoppingCart.reduce_item_quantity_by_one(cart_item).quantity == 1
    end

    test "prune_cart_items/1 returns an empty cart", %{cart: cart, product: product} do
      cart_with_one_item = add_cart_item_fixture(cart, product)

      assert {:ok, %Cart{} = cart} = ShoppingCart.prune_cart_items(cart_with_one_item)
      assert cart.items == []
    end
  end
end
