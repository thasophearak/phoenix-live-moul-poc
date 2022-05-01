defmodule Moul.Repo do
  use Ecto.Repo,
    otp_app: :moul,
    adapter: Ecto.Adapters.SQLite3
end
