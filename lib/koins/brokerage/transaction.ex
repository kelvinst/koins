defmodule Koins.Brokerage.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :notes, :string

    belongs_to :account, Koins.Brokerage.Account

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_id, :notes, :amount])
    |> validate_required([:account_id, :amount])
  end
end
