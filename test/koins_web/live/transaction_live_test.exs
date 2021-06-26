defmodule KoinsWeb.TransactionLiveTest do
  use KoinsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Koins.Brokerage

  @create_attrs %{amount: 42, notes: "some notes"}
  @update_attrs %{amount: 43, notes: "some updated notes"}
  @invalid_attrs %{amount: nil, notes: nil}

  defp put_assocs(default, account) do
    default
    |> Map.put(:account_id, account.id)
  end

  defp create_attrs(account), do: put_assocs(@create_attrs, account)
  defp update_attrs(account), do: put_assocs(@update_attrs, account)

  defp fixture(:transaction, account) do
    {:ok, transaction} = Brokerage.create_transaction(create_attrs(account))
    transaction
  end

  defp create_transaction(_tags) do
    {:ok, account} = Brokerage.create_account(%{name: "name"})
    transaction = fixture(:transaction, account)
    %{account: account, transaction: transaction}
  end

  describe "Index" do
    setup [:create_transaction]

    test "lists all transactions", %{conn: conn, transaction: transaction} do
      {:ok, _index_live, html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Listing Transactions"
      assert html =~ transaction.notes
    end

    test "saves new transaction", %{conn: conn, account: account} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("a", "New Transaction") |> render_click() =~
               "New Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :new))

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: create_attrs(account))
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction created successfully"
      assert html =~ "some notes"
    end

    test "updates transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, account} = Brokerage.create_account(%{name: "name"})
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("#transaction-#{transaction.id} a", "Edit") |> render_click() =~
               "Edit Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :edit, transaction))

      assert index_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: update_attrs(account))
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated notes"
    end

    test "deletes transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("#transaction-#{transaction.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#transaction-#{transaction.id}")
    end
  end

  describe "Show" do
    setup [:create_transaction]

    test "displays transaction", %{conn: conn, transaction: transaction} do
      {:ok, _show_live, html} = live(conn, Routes.transaction_show_path(conn, :show, transaction))

      assert html =~ "Show Transaction"
      assert html =~ transaction.notes
    end

    test "updates transaction within modal", %{conn: conn, transaction: transaction} do
      {:ok, account} = Brokerage.create_account(%{name: "name"})
      {:ok, show_live, _html} = live(conn, Routes.transaction_show_path(conn, :show, transaction))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Transaction"

      assert_patch(show_live, Routes.transaction_show_path(conn, :edit, transaction))

      assert show_live
             |> form("#transaction-form", transaction: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#transaction-form", transaction: update_attrs(account))
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_show_path(conn, :show, transaction))

      assert html =~ "Transaction updated successfully"
      assert html =~ "some updated notes"
    end
  end
end
