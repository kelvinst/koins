defmodule KoinsWeb.LiveHelpers do
  @moduledoc false

  import Phoenix.LiveView.Helpers

  alias Ecto.Changeset

  @doc """
  Renders a component inside the `KoinsWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, KoinsWeb.TransactionLive.FormComponent,
        id: @transaction.id || :new,
        action: @live_action,
        transaction: @transaction,
        return_to: Routes.transaction_index_path(@socket, :index) %>

  """
  @spec live_modal(Phoenix.Socket.t(), atom(), Keyword.t()) :: Phoenix.LiveView.Component.t()
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, KoinsWeb.ModalComponent, modal_opts)
  end

  @doc """
  Returns value for a money `field` on the `changeset` as a string.

  ## Examples

      iex> changeset = Transaction.changeset(%Transaction{}, %{amount: 100})
      iex> LiveHelpers.money_value(changeset, :amount)
      "1.00"

  """
  @spec money_value(Changeset.t(), atom()) :: String.t()
  def money_value(changeset, field) do
    changeset
    |> Changeset.get_field(field)
    |> money_value()
  end

  defp money_value(nil), do: nil
  defp money_value(%Money{} = value), do: Money.to_string(value, symbol: false)
end
