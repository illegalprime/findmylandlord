defmodule FindMyLandlordWeb.SearchLive do
  use FindMyLandlordWeb, :live_view

  def mount(_params, _session, socket) do
    socket
    |> assign(pick: nil)
    |> ok()
  end

  def handle_params(%{"s" => query},  _, socket) do
    socket
    |> assign(pick: query)
    |> noreply()
  end
  def handle_params(_,  _, socket), do: noreply(socket)

end
