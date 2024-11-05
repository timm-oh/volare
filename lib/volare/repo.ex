defmodule Volare.Repo do
  use Ecto.Repo,
    otp_app: :volare,
    adapter: Ecto.Adapters.Postgres
end
