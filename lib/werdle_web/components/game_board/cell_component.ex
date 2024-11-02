defmodule WerdleWeb.GameBoard.CellComponent do
  use WerdleWeb, :live_component
  alias Werdle.Game

  @impl true
  def update(
    %{id: id, changeset: changeset},
    socket
  ) do
    socket =
      socket
      |> assign(:id, id)
      |> assign(:changeset, changeset)
      |> assign(:background, socket.assigns[:background] || "bg-transparent")

    {:ok, socket}
  end

  @impl true
  def handle_event("cell_background_update", %{"background" => background}, socket) do
    # IO.inspect("handling event: #{inspect([background: background])}")
    socket = assign(socket, :background, "#{background} flip-cell")
    {:noreply, socket}
  end

  @impl true
  def render(%{id: id, changeset: changeset} = assigns) do
    [row, column] = get_row_and_column(id)
    input_value = Game.get_char_from_grid(changeset, row, column)
    assigns = assign(assigns, :input_value, input_value) # interesting, use assigns to feed in elixir variables

    ~H"""
    <div id={@id} class="relative sm:w-16 sm:h-16 h-14 w-14 col-span-1 pointer-events-none select-none">
      <input
        type="text"
         value={@input_value}
        class={"#{@background} uppercase w-full h-full p-3 text-slate-200 rounded-sm text-2xl text-center font-bold cursor-default"}
        maxlength="1" />
    </div>
    """
  end

  defp get_row_and_column(id) do
    [_, _, row, column] = String.split(id, "-")
    [String.to_integer(row), String.to_integer(column)]
  end

end
