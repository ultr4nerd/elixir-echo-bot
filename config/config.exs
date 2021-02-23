use Mix.Config

config :messenger_services, MessengerServicesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7Si5zPC9md5SsjrEdIpDYrXPVgZhpej8r/b3H8t6xi3Ao/CpK8UEbZeZCpX7siOy",
  render_errors: [view: MessengerServicesWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MessengerServices.PubSub,
  live_view: [signing_salt: "ygxqN3nv"]

config :messenger_services,
  verify_token: System.get_env("MESSENGER_VERIFY_TOKEN"),
  page_access_token: System.get_env("MESSENGER_PAGE_ACCESS_TOKEN")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
