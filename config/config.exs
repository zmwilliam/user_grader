# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :user_grader,
  ecto_repos: [UserGrader.Repo]

# Configures the endpoint
config :user_grader, UserGraderWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: UserGraderWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UserGrader.PubSub,
  live_view: [signing_salt: "GiGlwiRO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :user_grader, :grader_server,
  periodic_update_enabled: true,
  periodic_update_interval_ms: 60_000,
  minimum_points: 0,
  maximum_points: 100

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
