defmodule Eye2eyeWeb.CartView do
  use Eye2eyeWeb, :view

  alias Eye2eye.ShoppingCart.{Cart, CartItem}

  @min_cart_item_price Decimal.new("0.00")

  def total_cart_items(%Cart{} = cart) do
    Enum.reduce(cart.items, 0, fn item, acc ->
      item.quantity + acc
    end)
  end

  def total_cart_price(%Cart{} = cart) do
    Enum.reduce(cart.items, @min_cart_item_price, fn item, acc ->
      item
      |> total_item_price()
      |> Decimal.add(acc)
    end)
  end

  def total_item_price(%CartItem{} = item) do
    Decimal.mult(item.product.price, item.quantity)
  end
end
