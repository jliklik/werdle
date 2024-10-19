defmodule Werdle.Game.Guesses do
  use Ecto.Schema
  import Ecto.Changeset

  @guess_fields [:guess_0, :guess_1, :guess_2, :guess_3, :guess_4, :guess_5]

  embedded_schema do
    field :guess_0, {:array, :string}, default: []
    field :guess_1, {:array, :string}, default: []
    field :guess_2, {:array, :string}, default: []
    field :guess_3, {:array, :string}, default: []
    field :guess_4, {:array, :string}, default: []
    field :guess_5, {:array, :string}, default: []
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, @guess_fields)
    |> validate_guess_fields()
  end

  defp validate_guess_fields(changeset) do
    Enum.reduce(@guess_fields, changeset, fn field, acc_changeset ->
      validate_length(acc_changeset, field, is: 5, message: "should be five characters")
    end)
  end
end
