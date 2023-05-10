defmodule FindMyLandlord.Repo do
  use Ecto.Repo,
    otp_app: :find_my_landlord,
    adapter: Ecto.Adapters.Postgres
end
