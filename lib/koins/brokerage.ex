defmodule Koins.Brokerage do
  @moduledoc """
  The Brokerage context.
  """

  import Ecto.Query, warn: false
  alias Koins.Repo

  alias Koins.Brokerage.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  @spec list_transactions() :: [Transaction.t()]
  @spec list_transactions(Keyword.t()) :: [Transaction.t()]
  def list_transactions(opts \\ []) do
    Transaction
    |> build_transactions_query(opts)
    |> Repo.all()
  end

  defp build_transactions_query(q, []), do: order_by(q, desc: :inserted_at)

  defp build_transactions_query(q, [{:preload, value} | rest]) do
    q
    |> preload(^value)
    |> build_transactions_query(rest)
  end

  @doc """
  Returns the balance by suming all the transactions.

  ## Examples

      iex> balance()
      %Money{amount: 0}

  """
  @spec balance() :: Money.t()
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
  @spec get_transaction!(integer()) :: Transaction.t()
  @spec get_transaction!(integer(), Keyword.t()) :: Transaction.t()
  def get_transaction!(id, opts \\ []) do
    Transaction
    |> build_transactions_query(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_transaction(map()) :: {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def create_transaction(attrs) do
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
  @spec update_transaction(Transaction.t(), map()) ::
          {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
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
  @spec delete_transaction(Transaction.t()) :: {:ok, Transaction.t()}
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
  @spec change_transaction(Transaction.t()) :: Ecto.Changeset.t()
  @spec change_transaction(Transaction.t(), map()) :: Ecto.Changeset.t()
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  defp broadcast(transaction, action, extra_data \\ nil) do
    Phoenix.PubSub.broadcast(Koins.PubSub, "transactions", {action, transaction, extra_data})
  end

  alias Koins.Brokerage.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  @spec list_accounts() :: [Account.t()]
  @spec list_accounts(Keyword.t()) :: [Account.t()]
  def list_accounts(opts \\ []) do
    Account
    |> build_accounts_query(opts)
    |> Repo.all()
  end

  defp build_accounts_query(q, []), do: q

  defp build_accounts_query(q, [{:select, :for_options} | rest]) do
    q
    |> select([a], {a.name, a.id})
    |> build_accounts_query(rest)
  end

  @doc """
  Returns a list of accounts that match the `query_str`

  ## Examples

      iex> search_account("ca")
      %Account{name: "Cash"}

  """
  @spec search_account(String.t()) :: [Account.t()]
  @spec search_account(String.t(), Keyword.t()) :: [Account.t()]
  def search_account(query_str, opts \\ []) do
    query_str = "#{query_str}%"

    Account
    |> build_accounts_query(opts)
    |> where([a], ilike(a.name, ^query_str))
    |> Repo.all()
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_account!(integer()) :: Account.t()
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_account(map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_account(Account.t(), map()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_account(Account.t()) :: {:ok, Account.t()}
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  @spec change_account(Account.t()) :: Ecto.Changeset.t()
  @spec change_account(Account.t(), map()) :: Ecto.Changeset.t()
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
