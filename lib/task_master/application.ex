defmodule TaskMaster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaskMasterWeb.Telemetry,
      TaskMaster.Repo,
      {DNSCluster, query: Application.get_env(:task_master, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaskMaster.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaskMaster.Finch},
      # Start a worker by calling: TaskMaster.Worker.start_link(arg)
      # {TaskMaster.Worker, arg},
      # Start to serve requests, typically the last entry
      TaskMasterWeb.Endpoint,
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskMaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskMasterWeb.Endpoint.config_change(changed, removed)
    :ok
  end



  def oban_config do
    opts = Application.get_env(:task_master, Oban)

    if Code.ensure_loaded?(IEx) and IEx.started?() do
      opts
      |> Keyword.put(:crontab, false)
      |> Keyword.put(:queues, false)
    else
      opts
    end
  end



end
