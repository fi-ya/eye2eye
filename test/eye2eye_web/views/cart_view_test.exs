defmodule Eye2eyeWeb.CartViewTest do
  use Eye2eyeWeb.ConnCase, async: true

  alias Eye2eyeWeb.CartView

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

  @product_two_attrs %{
    name: "Product Two",
    image_url: "https://images.com/2",
    price: "100.00"
  }

  describe "total_cart_items" do
    setup [:create_product, :create_cart]

    test "when no cart items returns valid integer", %{cart: cart} do
      assert CartView.total_cart_items(cart) == 0
    end

    test "when one cart item returns valid integer", %{cart: cart, product: product} do
      cart_with_one_item = add_cart_item_fixture(cart, product)

      assert CartView.total_cart_items(cart_with_one_item) == 1
    end

    test "when one cart item with quantity two returns valid integer", %{cart: cart, product: product} do
      cart_with_item_q1 = add_cart_item_fixture(cart, product)
      cart_with_item_q2 = add_cart_item_fixture(cart_with_item_q1, product)

      assert CartView.total_cart_items(cart_with_item_q2) == 2
    end

    test "when two cart items with different quantities returns valid integer", %{cart: cart, product: product} do
      cart_with_item_q1 = add_cart_item_fixture(cart, product)
      cart_with_item_q2 = add_cart_item_fixture(cart_with_item_q1, product)
      product_two = create_product_fixture(@product_two_attrs)
      cart_with_item_q3 = add_cart_item_fixture(cart_with_item_q2, product_two)

      assert CartView.total_cart_items(cart_with_item_q3) == 3
    end
  end

  describe "total_cart_price" do
    setup [:create_product, :create_cart]

    test "when cart empty returns valid decimal", %{cart: cart} do
      assert CartView.total_cart_price(cart) === Decimal.new("0.00")
    end

    test "when cart has one item returns valid decimal", %{cart: cart, product: product} do
      cart_with_item_q1 = add_cart_item_fixture(cart, product)

      assert CartView.total_cart_price(cart_with_item_q1) === Decimal.new("120.50")
    end

    test "when cart has two items returns valid decimal", %{cart: cart, product: product} do
      cart_with_item1 = add_cart_item_fixture(cart, product)
      product_two = create_product_fixture(@product_two_attrs)
      cart_with_item2 = add_cart_item_fixture(cart_with_item1, product_two)

      assert CartView.total_cart_price(cart_with_item2) === Decimal.new("220.50")
    end
  end

  describe "total_item_price" do
    setup [:create_product, :create_cart]

    test "where one cart item present with quantity one returns valid decimal", %{cart: cart, product: product} do
      cart_with_one_item = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item.items)

      assert cart_item.product.price === Decimal.new("120.50")
      assert cart_item.quantity === 1
      assert CartView.total_item_price(cart_item) === Decimal.new("120.50")
    end

    test "where one cart item present with quantity two returns valid decimal", %{cart: cart, product: product} do
      _cart_with_one_item_q1 = add_cart_item_fixture(cart, product)
      cart_with_one_item_q2 = add_cart_item_fixture(cart, product)
      cart_item = List.first(cart_with_one_item_q2.items)

      assert cart_item.product.price === Decimal.new("120.50")
      assert cart_item.quantity === 2
      assert CartView.total_item_price(cart_item) === Decimal.new("241.00")
    end
  end
end
