defmodule FindMyLandlordWeb.Live.Components.Search do
  use FindMyLandlordWeb, :live_component

  # as the user types, this event fires and updates the suggestion box
  def handle_event("suggest",  %{"query" => query}, socket) do
    socket
    |> assign(query: query)
    |> assign(suggestions: search(query))
    |> noreply()
  end

  # submit query
  def handle_event("submit",  %{"query" => query}, socket) do
    socket
    |> assign(query: query)
    |> push_navigate(to: ~p"/search?s=#{query}")
    |> noreply()
  end

  # takes a query, normalizes it, and searches it against the database
  def search(""), do: []

  def search(query) do
    normalize = fn s -> String.downcase(s) end
    fake_data()
    |> Enum.filter(fn data ->
      String.contains?(normalize.(data), normalize.(query))
    end)
    |> Enum.take(5) # limit to 5 results
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
