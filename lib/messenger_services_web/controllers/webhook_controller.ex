defmodule MessengerServicesWeb.WebhookController do
  use MessengerServicesWeb, :controller
  alias MessengerServices.Webhook

  @verify_token Application.fetch_env!(:messenger_services, :verify_token)

  @spec echo_message(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def echo_message(conn, %{"object" => "page", "entry" => entries}) do
    Enum.each(entries, &handle_webhook/1)
    send_resp(conn, 200, "EVENT_RECEIVED")
  end

  def echo_message(conn, _params) do
    conn
    |> put_status(404)
    |> render("error.json", detail: "Event is not from a page subscription")
  end

  @spec verify(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def verify(conn, %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => @verify_token,
        "hub.challenge" => challenge
      }) do
    send_resp(conn, 200, challenge)
  end

  def verify(conn, _params) do
    conn
    |> put_status(403)
    |> render("error.json", detail: "Forbidden")
  end

  defp handle_webhook(entry) do
    entry["messaging"]
    |> List.first()
    |> Webhook.handle_event()
  end
end
