defmodule Koins.Brokerage.Account do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Koins.Brokerage.Account

  @type t :: %Account{}

  schema "accounts" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset that changes the `attrs` from `account`

  Always returns a `%Ecto.Changeset{}`

  ### Examples
      
      iex> changeset = Account.changeset(%Account{}, %{name: "test"})
      iex> changeset.valid?
      true
      iex> changeset.changes
      %{name: "test"}

      iex> changeset = Account.changeset(%Account{}, %{})
      iex> changeset.valid?
      false
      iex> changeset.errors
      [
        name: {"can't be blank", [validation: :required]}
      ]

  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
