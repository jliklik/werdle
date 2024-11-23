defmodule WerdleWeb.GameBoard.KeyboardComponent do
  use WerdleWeb, :live_component

  @keyboard_rows [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["enter", "z", "x", "c", "v", "b", "n", "m", "backspace"]
  ]

  @impl true
  def update(%{id: id}, socket) do
    socket =
      socket
      |> assign(:id, id)
      |> assign(:keyboard_rows, @keyboard_rows)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} class="w-full h-full">
      <%= for keyboard_row <- @keyboard_rows do %>
        <div class="flex justify-center gap-1 mb-1.5 w-full sm:h-full h-14">
        <%= for keycap_value <- keyboard_row do %>
          <.live_component
            module={WerdleWeb.GameBoard.KeycapComponent}
            id={"keycap-#{keycap_value}"}
            keycap_value={keycap_value}
          />
        <% end %>
        </div>
      <% end %>
    </div>
    """
  end

end
