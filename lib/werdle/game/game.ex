defmodule Werdle.Game do

  alias Werdle.Game.Guesses

  def change_guesses(attrs \\ %{}) do
    Guesses.changeset(attrs)
  end

end
