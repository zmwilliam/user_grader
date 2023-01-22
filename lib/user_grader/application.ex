defmodule UserGrader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      UserGrader.Repo,
      # Start the Telemetry supervisor
      UserGraderWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: UserGrader.PubSub},
      # Start the Endpoint (http/https)
      UserGraderWeb.Endpoint,
      # Start a worker by calling: UserGrader.Worker.start_link(arg)
      # {UserGrader.Worker, arg}

      {Task.Supervisor, name: UserGrader.TaskSupervisor}
    ]

    all_chidren = children ++ env_based_children(Mix.env())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserGrader.Supervisor]
    Supervisor.start_link(all_chidren, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UserGraderWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp env_based_children(:test), do: []

  defp env_based_children(_env), do: [UserGrader.GraderServer]
end
