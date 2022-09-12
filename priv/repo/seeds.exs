# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eye2eye.Repo.insert!(%Eye2eye.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Eye2eye.Repo
alias Eye2eye.Catalog
alias Eye2eye.Catalog.Product

Repo.delete_all(Product)

for i <- 1..10 do
  product_name = [
    "Malcom",
    "Bobby",
    "Franklin",
    "Ken",
    "Rita",
    "Edna",
    "Clark",
    "Lennon",
    "Basic",
    "Snazzy"
  ]

  img_url = [
    "https://images.unsplash.com/photo-1574258495973-f010dfbb5371?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2370&q=80",
    "https://images.unsplash.com/photo-1603578119639-798b8413d8d7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
    "https://images.unsplash.com/photo-1582478134397-2b32c067e22d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
    "https://images.unsplash.com/photo-1589176449149-71f7ea77ec25?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    "https://images.unsplash.com/photo-1534844978-b859e5a09ad6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
    "https://images.unsplash.com/photo-1641048927024-0e801784b4f7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHJvdW5kJTIwZ2xhc3Nlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60",
    "https://images.unsplash.com/photo-1475312775467-159e03aaa7cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
    "https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80",
    "https://images.unsplash.com/photo-1483412468200-72182dbbc544?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1773&q=80",
    "https://images.unsplash.com/photo-1542629458-eaa56d608062?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1767&q=80"
  ]

  {:ok, _} =
    Catalog.create_product(%{
      name: "#{Enum.at(product_name, i - 1)}",
      image_url: "#{Enum.at(img_url, i - 1)}",
      price: "#{100 + i}"
    })
end
