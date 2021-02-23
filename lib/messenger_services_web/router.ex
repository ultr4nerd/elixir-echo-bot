defmodule MessengerServicesWeb.Router do
  use MessengerServicesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MessengerServicesWeb do
    pipe_through :api

    get "/webhook", WebhookController, :verify
    post "/webhook", WebhookController, :echo_message
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MessengerServicesWeb.Telemetry
    end
  end
end
