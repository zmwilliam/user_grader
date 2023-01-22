defmodule UserGrader.Repo do
  use Ecto.Repo,
    otp_app: :user_grader,
    adapter: Ecto.Adapters.Postgres
end
