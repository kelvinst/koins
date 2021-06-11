defmodule Koins.Repo.Migrations.AddDateToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :date, :date
    end

    create index(:transactions, :date)
  end
end
