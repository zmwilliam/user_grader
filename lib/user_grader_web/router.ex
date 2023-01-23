defmodule UserGraderWeb.Router do
  use UserGraderWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserGraderWeb do
    pipe_through :api

    get "/", UsersPointsController, :get
  end
end
