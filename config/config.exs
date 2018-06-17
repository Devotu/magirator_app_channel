# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :magirator_app_channel, MagiratorAppChannelWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4NJJ/UhRvH4hLXqe1fKrBFcH17mFROdYpQqbEj+03VVxpXG2w+9pvbFA77PReMpq",
  render_errors: [view: MagiratorAppChannelWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MagiratorAppChannel.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Neo4j driver
config :bolt_sips, Bolt,
  hostname: 'localhost',
  basic_auth: [username: "neo4j", password: "neo4j400"],
  port: 7401,
  pool_size: 5,
  max_overflow: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
