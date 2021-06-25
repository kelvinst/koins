defmodule Koins.Brokerage.Transaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Koins.Brokerage.Transaction

  @type t :: %Transaction{}

  schema "transactions" do
    field :date, :date, default: Date.utc_today()
    field :amount, Money.Ecto.Amount.Type
    field :notes, :string

    belongs_to :account, Koins.Brokerage.Account

    timestamps()
  end

  @doc """
  Builds a changeset that changes the `attrs` from `transaction`

  Always returns a `%Ecto.Changeset{}`

  ### Examples
      
      iex> changes = %{date: ~D[2020-10-10], amount: 1000, account_id: 1}
      iex> changeset = Transaction.changeset(%Transaction{}, changes)
      iex> changeset.valid?
      true
      iex> changeset.changes
      %{date: ~D[2020-10-10], amount: %Money{amount: 1000}, account_id: 1}

      iex> changeset = Transaction.changeset(%Transaction{}, %{})
      iex> changeset.valid?
      false
      iex> changeset.errors
      [
        account_id: {"can't be blank", [validation: :required]}, 
        amount: {"can't be blank", [validation: :required]}
      ]

  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_id, :date, :notes, :amount])
    |> validate_required([:account_id, :date, :amount])
  end
end
