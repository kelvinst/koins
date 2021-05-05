defmodule Koins.Repo do
  use Ecto.Repo,
    otp_app: :koins,
    adapter: Ecto.Adapters.Postgres
end
