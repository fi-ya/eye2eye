defmodule Eye2eye.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Eye2eye.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Eye2eye.PubSub},
      # Start the Endpoint (http/https)
      Eye2eyeWeb.Endpoint
      # Start a worker by calling: Eye2eye.Worker.start_link(arg)
      # {Eye2eye.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eye2eye.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Eye2eyeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
