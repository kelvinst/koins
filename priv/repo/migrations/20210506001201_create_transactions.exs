defmodule Koins.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :notes, :string
      add :amount, :integer

      timestamps()
    end

  end
end
