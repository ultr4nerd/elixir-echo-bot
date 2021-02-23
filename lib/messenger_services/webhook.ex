defmodule MessengerServices.Webhook do
  @page_access_token Application.get_env(:messenger_services, :page_access_token)

  @spec handle_event(map()) :: nil
  def handle_event(%{"message" => received_message, "sender" => %{"id" => sender_psid}}) do
    handle_message(sender_psid, received_message)
  end

  def handle_event(_webhook_event) do
    IO.puts "Invalid webhook event"
  end

  defp handle_message(sender_psid, %{"text" => text}) do
    response = %{text: "Dijiste: \"#{text}\""}
    call_send_api(sender_psid, response)
  end

  defp handle_message(sender_psid, _received_message) do
    response = %{text: "Unsupported kind of message"}
    call_send_api(sender_psid, response)
  end

  defp call_send_api(sender_psid, response) do
    url = "https://graph.facebook.com/me/messages"
    request_body = Poison.encode!(%{
      recipient: %{
        id: sender_psid
      },
      message: response
    })
    headers = %{"Content-Type" => "application/json"}
    options = [params: %{access_token: @page_access_token}]

    case HTTPoison.post(url, request_body, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"recipient_id" => recipient_id} = Poison.decode!(body)
        IO.puts "Message sent to #{recipient_id}"
      {:ok, %HTTPoison.Response{body: body}} ->
        IO.puts "Something went wrong: #{body}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end

  end

end
