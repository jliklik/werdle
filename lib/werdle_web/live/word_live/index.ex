defmodule WerdleWeb.WordLive.Index do
  use WerdleWeb, :live_view

  alias Werdle.{WordBank, Game}

  @impl true
  def mount(_params, _session, socket) do

    socket =
      socket
      |> assign(:solve, WordBank.random_solve()) # assign answer to the game
      |> assign(:changeset, Game.change_guesses())
      |> assign(:current_guess, 0)

    {:ok, socket}
  end

  @impl true
  def handle_info(:new_game, socket) do
    IO.inspect("Starting new game")
    {:noreply, push_navigate(socket, to: "/")}
  end

  @impl true
  @spec handle_event(<<_::40, _::_*8>>, any(), any()) :: {:noreply, any()}
  def handle_event("letter", %{"key" => key}, socket) do
    changeset = socket.assigns.changeset
    guess_row = socket.assigns.current_guess

    IO.inspect(changeset, limit: :infinity)

    if Game.five_char_guess?(changeset, guess_row) do
      {:noreply, socket}
    else
      socket = assign(socket, :changeset, Game.update_guesses(changeset, key, guess_row))
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("backspace", _params, socket) do
    changeset = socket.assigns.changeset
    guess_row = socket.assigns.current_guess
    socket =
      socket
      |> assign(:changeset, Game.remove_last_char(changeset, guess_row))

    {:noreply, socket}
  end

  @impl true
  def handle_event("enter", _params, socket) do
    changeset = socket.assigns.changeset
    guess_row = socket.assigns.current_guess
    solve = socket.assigns.solve

    with {:ok, _changeset} <- Game.validate_guess(changeset, guess_row),
         {:correct, _changeset}<- Game.check_guess_correctness(changeset, guess_row, solve)
    do
      IO.inspect("correct guess")
      Process.send_after(self(), :new_game, 7500)
      {:noreply, handle_correct_guess(socket)}
    else
      {:error, error_message} ->
        IO.inspect("error")
        {:noreply, handle_invalid_guess(socket, error_message)}
      {:incorrect, _changeset} when guess_row == 5 ->
        IO.inspect("game_over")
        Process.send_after(self(), :new_game, 7500)
        {:noreply, handle_game_over(socket)}
      {:incorrect, _changeset} ->
        IO.inspect("incorrect guess")
        {:noreply, handle_incorrect_guess(socket)}
    end

  end

  defp handle_correct_guess(socket) do
    message = "You won! #{String.upcase(socket.assigns.solve.name)} was the correct word"
    create_guess_response(socket, message)
  end

  defp handle_invalid_guess(socket, error_message) do
    socket
    |> push_event("guess-validation-text", %{message: error_message})
    |> push_event("shake-row", %{row: socket.assigns.current_guess}) # payload is the row
  end

  defp handle_game_over(socket) do
    message = "The solve was #{String.upcase(socket.assigns.solve.name)}"

    socket
    |> create_guess_response(message)
    |> push_event("guess-validation-text", %{message: message})
  end

  defp handle_incorrect_guess(socket) do
    socket
    |> create_guess_response(nil)
    |> push_event("shake-row", %{row: socket.assigns.current_guess}) # payload is the row
    |> assign(:current_guess, socket.assigns.current_guess + 1)
  end

  defp create_guess_response(socket, message) do
    guess_row = socket.assigns.current_guess
    comparison_results =
      Game.compare_guess(socket.assigns.changeset, guess_row, socket.assigns.solve.name)

    IO.inspect(comparison_results, label: "comparison_results")

    letter_statuses =
      Enum.map(comparison_results, fn {_letter, letter_status} -> letter_status end)

    socket
    |> maybe_push_event("guess-validation-text", message)
    |> push_event("guess-reveal-animation", %{
      guess_row: guess_row,
      letter_statuses: letter_statuses,
      comparison_results: Map.new(comparison_results)
    })
  end

  defp maybe_push_event(socket, nil, _), do: socket
  defp maybe_push_event(socket, event, message) do
    IO.inspect("pushing event: #{inspect([event: event, message: message])}")
    push_event(socket, event, %{message: message})
  end

end
