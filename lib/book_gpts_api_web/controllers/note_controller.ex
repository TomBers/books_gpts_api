defmodule BookGptsApiWeb.NoteController do
  use BookGptsApiWeb, :controller

  alias ElixirSense.Plugins.Ecto.Schema
  alias BookGptsApi.Notes
  alias BookGptsApi.Notes.Note

  use PhoenixSwagger

  action_fallback BookGptsApiWeb.FallbackController

  def index(conn, _params) do
    notes = Notes.list_notes()
    render(conn, :index, notes: notes)
  end

  def swagger_definitions do
    %{
      Note: swagger_schema do
        title "Note"
        description "A note in the application"
        properties do
          quote :string, "Quote of the note", required: true
          notes :array, "Notes associated with the quote", items: %{type: :string}
        end
        example %{
          quote: "some quote",
          notes: ["option1", "option2"]
        }
      end
    }
  end

  swagger_path :create do
    post "/api/notes"
    description "Create a new note"
    parameters do
      note :body, Schema.ref(:Note), "Note to be created", required: true
    end
    response 201, "Note created", Schema.ref(:Note)
    response 422, "Invalid data"
  end

  def create(conn, %{"note" => note_params}) do

    case Notes.get_note_by_quote(note_params["quote"]) do
      nil ->
        with {:ok, %Note{} = note} <- Notes.create_note(note_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/notes/#{note}")
          |> render(:show, note: note)
        end
      %Note{} = existing_note ->
        updated_note_params = Map.put(note_params, "notes", note_params["notes"] ++ existing_note.notes)

        with {:ok, %Note{} = note} <- Notes.update_note(existing_note, updated_note_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/notes/#{note}")
          |> render(:show, note: note)
        end
    end

    # with {:ok, %Note{} = note} <- Notes.create_note(note_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", ~p"/api/notes/#{note}")
    #   |> render(:show, note: note)
    # end
  end

  def show(conn, %{"id" => book_quote}) do
    note = Notes.get_note_by_quote(book_quote)
    render(conn, :show, note: note)
  end

  swagger_path :show_by_quote do
    get "/api/notes/{quote}"
    description "Get a note by quote"
    parameters do
      quote :path, :string, "Quote of the note", required: true
    end
    response 200, "Note found", Schema.ref(:Note)
    response 404, "Note not found"
  end

  # def show_by_quote(conn, %{"quote" => book_quote}) do
  #   note = Notes.get_note_by_quote(book_quote)

  #   render(conn, :show, note: note)
  # end

  # def show_by_quote(conn, params) do
  #   note = Notes.get_note_by_quote("2nd API generated quote")

  #   render(conn, :show, note: note)
  # end


  # def update(conn, %{"id" => id, "note" => note_params}) do
  #   note = Notes.get_note!(id)

  #   with {:ok, %Note{} = note} <- Notes.update_note(note, note_params) do
  #     render(conn, :show, note: note)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   note = Notes.get_note!(id)

  #   with {:ok, %Note{}} <- Notes.delete_note(note) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end


end
