defmodule Koins.Bank do
  @moduledoc """
  The Bank context.
  """

  import Ecto.Query, warn: false
  alias Koins.Repo

  alias Koins.Bank.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Transaction
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the balance by suming all the transactions.

  ## Examples

      iex> balance()
      %Money{amount: 0}
  """
  def balance do
    Transaction
    |> select([t], sum(t.amount))
    |> Repo.one()
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    with {:ok, transaction} <- do_create_transaction(attrs) do
      broadcast(transaction, :created)
      {:ok, transaction}
    end
  end

  defp do_create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    with {:ok, updated} <- do_update_transaction(transaction, attrs) do
      broadcast(transaction, :updated, %{
        amount_delta: Money.subtract(updated.amount, transaction.amount)
      })

      {:ok, updated}
    end
  end

  defp do_update_transaction(transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    with {:ok, transaction} <- Repo.delete(transaction) do
      broadcast(transaction, :deleted)
      {:ok, transaction}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  defp broadcast(transaction, action, extra_data \\ nil) do
    Phoenix.PubSub.broadcast(Koins.PubSub, "transactions", {action, transaction, extra_data})
  end
end
