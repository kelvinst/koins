defmodule Koins.Repo.Migrations.RenameDescToNotes do
  use Ecto.Migration

  def change do
    rename table(:transactions), :desc, to: :notes
  end
end
