defmodule Volare.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VolareWeb.Telemetry,
      Volare.Repo,
      {DNSCluster, query: Application.get_env(:volare, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Volare.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Volare.Finch},
      # Start a worker by calling: Volare.Worker.start_link(arg)
      # {Volare.Worker, arg},
      # Start to serve requests, typically the last entry
      VolareWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Volare.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VolareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
