defmodule BookGptsApiWeb.NoteJSON do
  alias BookGptsApi.Notes.Note

  @doc """
  Renders a list of notes.
  """
  def index(%{notes: notes}) do
    %{data: for(note <- notes, do: data(note))}
  end

  @doc """
  Renders a single note.
  """
  def show(%{note: note}) do
    # %{data: data(note)}
    data(note)
  end

  # def show_by_quote(%{note: note}) do
  #   %{data: %{notes: note}}
  # end

  defp data(%Note{} = note) do
    %{
      # id: note.id,
      quote: note.quote,
      notes: note.notes
    }
  end
end
