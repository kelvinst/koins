defmodule Koins.Bank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:notes, :amount])
    |> validate_required([:amount])
  end
end
