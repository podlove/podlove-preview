# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :instalove, InstaloveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XmhUtY/Mdf2U7As2e6Rvr+RVyq8Y6qVxJZcr62cOAcfu2ZgTd+vO7FwlNjhajRU6",
  render_errors: [view: InstaloveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Instalove.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
