defmodule KoinsWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

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
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, KoinsWeb.ModalComponent, modal_opts)
  end

  def money_value(changeset, field) do
    changeset
    |> Ecto.Changeset.get_field(field)
    |> money_value()
  end

  defp money_value(nil), do: nil
  defp money_value(value), do: Money.to_string(value, symbol: false)
end
