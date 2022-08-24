defmodule Eye2eyeWeb.PageController do
  use Eye2eyeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
