defmodule UserGraderWeb.Router do
  use UserGraderWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UserGraderWeb do
    pipe_through :api
  end
end
