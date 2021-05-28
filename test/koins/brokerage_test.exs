defmodule Koins.BrokerageTest do
  use Koins.DataCase

  alias Koins.Brokerage

  describe "transactions" do
    alias Koins.Brokerage.Transaction

    @valid_attrs %{amount: 42, notes: "some notes"}
    @update_attrs %{amount: 43, notes: "some updated notes"}
    @invalid_attrs %{amount: nil, notes: nil}

    def put_assocs(default, attrs) do
      account = account_fixture()

      attrs
      |> Enum.into(default)
      |> Map.put(:account_id, account.id)
    end

    def valid_attrs(attrs \\ %{}), do: put_assocs(@valid_attrs, attrs)
    def update_attrs(attrs \\ %{}), do: put_assocs(@update_attrs, attrs)

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> valid_attrs()
        |> Brokerage.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Brokerage.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Brokerage.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Brokerage.create_transaction(valid_attrs())
      assert transaction.amount == Money.new(42)
      assert transaction.notes == "some notes"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Brokerage.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Brokerage.update_transaction(transaction, update_attrs())

      assert transaction.amount == Money.new(43)
      assert transaction.notes == "some updated notes"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Brokerage.update_transaction(transaction, @invalid_attrs)

      assert transaction == Brokerage.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Brokerage.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Brokerage.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Brokerage.change_transaction(transaction)
    end
  end

  describe "accounts" do
    alias Koins.Brokerage.Account

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Brokerage.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Brokerage.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Brokerage.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Brokerage.create_account(@valid_attrs)
      assert account.name == "some name"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Brokerage.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Brokerage.update_account(account, @update_attrs)
      assert account.name == "some updated name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Brokerage.update_account(account, @invalid_attrs)
      assert account == Brokerage.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Brokerage.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Brokerage.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Brokerage.change_account(account)
    end
  end
end
