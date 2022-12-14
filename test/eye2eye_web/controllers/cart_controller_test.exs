defmodule Eye2eyeWeb.CartControllerTest do
  use Eye2eyeWeb.ConnCase

  import Eye2eye.CatalogFixtures

  alias Eye2eye.ShoppingCart

  @valid_cart_item_attrs %{quantity: 1}

  defp create_product(_) do
    product = create_product_fixture()
    %{product: product}
  end

  describe "show" do
    setup [:create_product]

    test "display message when cart empty", %{conn: conn} do
      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "Your cart is empty"
    end

    test "display cart item when there is an item in the cart", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, _cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "Product One"
      assert html_response(conn, 200) =~ "https://images.com/1"
      assert html_response(conn, 200) =~ "120.50"
    end
  end

  describe "update" do
    setup [:create_product]
    @invalid_cart_item_attrs %{quantity: 0}

    test "when item quantity one, display empty cart message when item quantity removed", %{
      conn: conn,
      product: product
    } do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      cart_item_attrs = %{quantity: cart_item.quantity}

      conn =
        put(
          conn,
          Routes.cart_path(conn, :update, item_id: cart_item.id, cart_item_attrs: cart_item_attrs)
        )

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "Your cart is empty"
      assert html_response(conn, 200) != "Product One"
      assert conn.assigns.cart.items == []
    end

    test "renders errors when cart item data is invalid", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, cart_item} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      conn =
        put(
          conn,
          Routes.cart_path(conn, :update,
            item_id: cart_item.id,
            cart_item_attrs: @invalid_cart_item_attrs
          )
        )

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert html_response(conn, 200) =~ "There was an error updating your cart"
    end

    test "when item quantity two display updates when a cart item quantity removed", %{
      conn: conn,
      product: product
    } do
      conn = get(conn, Routes.product_path(conn, :index))

      {:ok, _cart_item_q1} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      {:ok, cart_item_q2} =
        ShoppingCart.add_item_to_cart(conn.assigns.cart, product, @valid_cart_item_attrs)

      conn = get(conn, Routes.cart_path(conn, :show))
      cart_item = List.first(conn.assigns.cart.items)
      cart_item_attrs = %{quantity: cart_item.quantity}

      assert cart_item.quantity == 2

      conn =
        put(
          conn,
          Routes.cart_path(conn, :update,
            item_id: cart_item_q2.id,
            cart_item_attrs: cart_item_attrs
          )
        )

      assert redirected_to(conn) == Routes.cart_path(conn, :show)

      conn = get(conn, Routes.cart_path(conn, :show))

      assert length(conn.assigns.cart.items) == 1
      assert List.first(conn.assigns.cart.items).quantity == 1
      assert html_response(conn, 200) =~ "Product One"
    end
  end
end
