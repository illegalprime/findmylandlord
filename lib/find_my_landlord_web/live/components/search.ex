defmodule FindMyLandlordWeb.Live.Components.Search do
  use FindMyLandlordWeb, :live_component

  # as the user types, this event fires and updates the suggestion box
  def handle_event("suggest",  %{"query" => query}, socket) do
    socket
    |> assign(query: query)
    |> assign(suggestions: search(query))
    |> noreply()
  end

  def handle_event("suggest",  %{"value" => query}, socket) do
    handle_event("suggest",  %{"query" => query}, socket)
  end

  # picks an item out of the suggestions box
  def handle_event("pick", %{"item" => item}, socket) do
    socket
    |> assign(pick: item)
    |> assign(query: item)
    |> assign(suggestions: [])
    |> assign(item_focus: nil)
    |> push_patch(to: ~p"/search?s=#{item}")
    |> noreply()
  end

  # input is blurred, hide suggestions
  def handle_event("hide-suggest", _, socket) do
    socket
    |> assign(suggestions: [])
    |> assign(item_focus: nil)
    |> noreply()
  end

  # move suggestion focus one item up
  def handle_event("set-focus", %{"key" => "ArrowUp"}, socket) do
    new_focus =
      case socket.assigns.item_focus do
        nil -> length(socket.assigns.suggestions) - 1
        0 -> nil
        x -> x - 1
      end
    socket
    |> assign(item_focus: new_focus)
    |> noreply()
  end

  # move suggestion focus one item down
  def handle_event("set-focus", %{"key" => "ArrowDown"}, socket) do
    new_focus =
      case socket.assigns.item_focus do
        nil -> 0
        x when x >= length(socket.assigns.suggestions) -> nil
        x -> x + 1
      end
    socket
    |> assign(item_focus: new_focus)
    |> noreply()
  end

  # fallback for non related key strokes
  def handle_event("set-focus", _, socket), do: {:noreply, socket}

  # submit query
  def handle_event("submit",  %{"query" => query}, socket) do
    pick =
      case socket.assigns.item_focus do
        nil -> query
        idx when length(socket.assigns.suggestions) > idx ->
          Enum.at(socket.assigns.suggestions, idx)
        _ -> query
      end
    handle_event("pick", %{"item" => pick}, socket)
  end

  @doc """
  takes a query, normalizes it, and searches it against the database
  """
  def search(""), do: []

  def search(query) do
    fake_data()
    |> Enum.filter(fn data ->
      String.contains?(normalize(data), normalize(query))
    end)
    |> Enum.take(5) # limit to 5 results
  end

  @doc """
  cleans input in preparation for searching
  """
  def normalize(query) do
    String.downcase(query)
  end

  @doc """
  fake data until we get real data
  """
  def fake_data, do: [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California",
    "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
    "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
    "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
    "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
  ]
end
