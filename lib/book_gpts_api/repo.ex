defmodule BookGptsApi.Repo do
  use Ecto.Repo,
    otp_app: :book_gpts_api,
    adapter: Ecto.Adapters.Postgres
end
