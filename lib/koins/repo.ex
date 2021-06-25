defmodule Koins.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :koins,
    adapter: Ecto.Adapters.Postgres
end
