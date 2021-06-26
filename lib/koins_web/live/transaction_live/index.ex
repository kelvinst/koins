defmodule KoinsWeb.TransactionLive.Index do
  @moduledoc false

  use KoinsWeb, :live_view

  alias Koins.Brokerage
  alias Koins.Brokerage.Transaction

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Koins.PubSub, "transactions")

    {:ok,
     socket
     |> assign(:transactions, list_transactions())
     |> assign(:balance, balance())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Brokerage.get_transaction!(id))
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

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Brokerage.get_transaction!(id)
    {:ok, _} = Brokerage.delete_transaction(transaction)

    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  @impl Phoenix.LiveView
  def handle_info({:created, transaction, _}, socket) do
    {:noreply,
     socket
     |> update(:transactions, fn transactions -> [transaction | transactions] end)
     |> update(:balance, fn balance -> Money.add(balance, transaction.balance) end)}
  end

  def handle_info({:updated, _transaction, %{amount_delta: delta}}, socket) do
    {:noreply,
     socket
     |> assign(:transactions, list_transactions())
     |> update(:balance, fn balance -> Money.add(balance, delta) end)}
  end

  def handle_info({:deleted, transaction, _}, socket) do
    {:noreply,
     socket
     |> assign(:transactions, list_transactions())
     |> update(:balance, fn balance -> Money.subtract(balance, transaction.amount) end)}
  end

  defp list_transactions do
    Brokerage.list_transactions(preload: [:account])
  end

  defp balance do
    Brokerage.balance()
  end
end
