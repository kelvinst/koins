defmodule KoinsWeb.TransactionLive.Index do
  use KoinsWeb, :live_view

  alias Koins.Bank
  alias Koins.Bank.Transaction

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Koins.PubSub, "transactions")

    {:ok,
     socket
     |> assign(:transactions, list_transactions())
     |> assign(:balance, balance())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Bank.get_transaction!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Bank.get_transaction!(id)
    {:ok, _} = Bank.delete_transaction(transaction)

    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  @impl true
  def handle_info({:create, transaction}, socket) do
    {:noreply, assign(socket, :transactions, [transaction | socket.assigns.transactions])}
  end

  defp list_transactions do
    Bank.list_transactions()
  end

  defp balance do
    Bank.balance()
  end
end
