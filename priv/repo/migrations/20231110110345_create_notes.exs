defmodule BookGptsApi.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :quote, :string
      add :notes, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
