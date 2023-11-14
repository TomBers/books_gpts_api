defmodule BookGptsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BookGptsApiWeb.Telemetry,
      BookGptsApi.Repo,
      {DNSCluster, query: Application.get_env(:book_gpts_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BookGptsApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BookGptsApi.Finch},
      # Start a worker by calling: BookGptsApi.Worker.start_link(arg)
      # {BookGptsApi.Worker, arg},
      # Start to serve requests, typically the last entry
      BookGptsApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookGptsApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookGptsApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
