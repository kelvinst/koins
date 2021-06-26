# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule KoinsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use KoinsWeb, :controller
      use KoinsWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @spec view() :: tuple()
  def view do
    quote do
      use Phoenix.View,
        root: "lib/koins_web/templates",
        namespace: KoinsWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  @spec live_view() :: tuple()
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {KoinsWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  @spec live_component() :: tuple()
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  @spec view_helpers() :: tuple()
  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers
      import KoinsWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import KoinsWeb.ErrorHelpers
      import KoinsWeb.Gettext

      # credo:disable-for-next-line Credo.Check.Readability.AliasAs
      alias KoinsWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
