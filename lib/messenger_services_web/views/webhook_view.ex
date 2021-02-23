defmodule MessengerServicesWeb.WebhookView do
  use MessengerServicesWeb, :view

  def render("error.json", %{detail: detail}) do
    %{errors: %{detail: detail}}
  end
end
