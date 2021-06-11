defmodule Koins.Repo.Migrations.AddAccountIdToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
    end

    create index(:transactions, :account_id)
  end
end
