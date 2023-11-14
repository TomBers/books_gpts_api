defmodule BookGptsApi.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :quote, :string
    field :notes, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:quote, :notes])
    |> validate_required([:quote, :notes])
  end
end
