defmodule Koins.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string

      timestamps()
    end

  end
end
