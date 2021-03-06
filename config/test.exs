use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :magirator_app_channel, MagiratorAppChannelWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
# :warn = only warnings, :debug = including Logger.debug 
config :logger, level: :warn
