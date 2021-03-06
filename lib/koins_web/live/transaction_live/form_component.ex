defmodule KoinsWeb.TransactionLive.FormComponent do
  @moduledoc false

  use KoinsWeb, :live_component

  alias Koins.Brokerage

  @impl Phoenix.LiveComponent
  def update(%{transaction: transaction} = assigns, socket) do
    account_options = Brokerage.list_accounts(select: :for_options)
    changeset = Brokerage.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:account_options, account_options)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Brokerage.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Brokerage.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Brokerage.create_transaction(transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
