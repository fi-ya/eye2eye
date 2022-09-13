defmodule Eye2eyeWeb.LayoutView do
  use Eye2eyeWeb, :view

  alias Eye2eyeWeb.CartView

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
