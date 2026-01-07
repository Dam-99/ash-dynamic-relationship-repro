defmodule DynRelRepro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DynRelReproWeb.Telemetry,
      DynRelRepro.Repo,
      {DNSCluster, query: Application.get_env(:dyn_rel_repro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DynRelRepro.PubSub},
      # Start a worker by calling: DynRelRepro.Worker.start_link(arg)
      # {DynRelRepro.Worker, arg},
      # Start to serve requests, typically the last entry
      DynRelReproWeb.Endpoint,
      {Absinthe.Subscription, DynRelReproWeb.Endpoint},
      AshGraphql.Subscription.Batcher
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DynRelRepro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DynRelReproWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
