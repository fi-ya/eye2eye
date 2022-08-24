defmodule Eye2eye.Repo do
  use Ecto.Repo,
    otp_app: :eye2eye,
    adapter: Ecto.Adapters.Postgres
end
