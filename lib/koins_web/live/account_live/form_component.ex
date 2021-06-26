defmodule KoinsWeb.AccountLive.FormComponent do
  @moduledoc false

  use KoinsWeb, :live_component

  alias Koins.Brokerage

  @impl true
  def update(%{account: account} = assigns, socket) do
    changeset = Brokerage.change_account(account)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"account" => account_params}, socket) do
    changeset =
      socket.assigns.account
      |> Brokerage.change_account(account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"account" => account_params}, socket) do
    save_account(socket, socket.assigns.action, account_params)
  end

  defp save_account(socket, :edit, account_params) do
    case Brokerage.update_account(socket.assigns.account, account_params) do
      {:ok, _account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_account(socket, :new, account_params) do
    case Brokerage.create_account(account_params) do
      {:ok, _account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
