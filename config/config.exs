# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :koins,
  ecto_repos: [Koins.Repo]

# Configures the endpoint
config :koins, KoinsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LzkRjMOrTimxHD+urDnAaI4cDfE8hVQ0prM+nMWcNSFKUJ4GydB0+cK5JHSpRKZE",
  render_errors: [view: KoinsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Koins.PubSub,
  live_view: [signing_salt: "QDXyi3H9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money, default_currency: :USD

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
