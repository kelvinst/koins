defmodule KoinsWeb.AccountLive.Index do
  @moduledoc false

  use KoinsWeb, :live_view

  alias Koins.Brokerage
  alias Koins.Brokerage.Account

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :accounts, list_accounts())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Account")
    |> assign(:account, Brokerage.get_account!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Account")
    |> assign(:account, %Account{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accounts")
    |> assign(:account, nil)
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    account = Brokerage.get_account!(id)
    {:ok, _} = Brokerage.delete_account(account)

    {:noreply, assign(socket, :accounts, list_accounts())}
  end

  defp list_accounts do
    Brokerage.list_accounts()
  end
end
