defmodule KoinsWeb.ErrorView do
  use KoinsWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".

  # Disabled spec check cause the overridable function does not have
  # the spec, so we can't define it in here too. Fixed on this commit
  # https://github.com/phoenixframework/phoenix/commit/6fbbc03ae88cb1cda33a9a79043aa5034420517b
  # credo:disable-for-next-line Credo.Check.Readability.Specs
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
