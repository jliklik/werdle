defmodule Werdle.Game do

  alias Werdle.Game.Guesses
  alias Ecto.Changeset

  def change_guesses(attrs \\ %{}) do
    Guesses.changeset(attrs)
  end

  def five_character_guess?(changeset, guess_row) do
    guess_field = guess_field(guess_row)
    char_count =
      changeset
      |> Changeset.get_change(guess_field, [])
      |> Enum.count()

    char_count == 5
  end

  def get_char_from_grid(changeset, row, column) do
    guess_field = guess_field(row)
    guess = Changeset.get_field(changeset, guess_field)
    Enum.at(guess, column)
  end

  def update_guesses(changeset, new_character, guess_row) do
    guess_field = guess_field(guess_row)
    if current_guess = Changeset.get_change(changeset, guess_field) do
      updated_guess = current_guess ++ [new_character] # append new character to guess
      changeset.changes
      |> Map.merge(%{guess_field => updated_guess})
      |> change_guesses()
    else
      change_guesses(%{guess_field => [new_character]})
    end
  end

  defp guess_field(row) do
    String.to_existing_atom("guess_#{row}")
  end

end
