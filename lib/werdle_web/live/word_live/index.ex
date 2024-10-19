defmodule WerdleWeb.WordLive.Index do
  use WerdleWeb, :live_view

  alias Werdle.WordBank
  alias Werdle.WordBank.Word
  alias Werdle.Game

  @impl true
  def mount(_params, _session, socket) do

    socket =
      socket
      |> assign(:cell_backgrounds, %{})
      |> assign(:keyboard_backgrounds, %{})
      |> assign(:changeset, Game.change_guesses())

    {:ok, socket}
  end

end
