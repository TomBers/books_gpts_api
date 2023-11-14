defmodule BookGptsApi.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookGptsApi.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        notes: ["option1", "option2"],
        quote: "some quote"
      })
      |> BookGptsApi.Notes.create_note()

    note
  end
end
