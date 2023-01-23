defmodule UserGraderWeb.UsersPointsController do
  use UserGraderWeb, :controller

  def get(conn, _params) do
    users_list_quantity = 2

    users_and_timestamp =
      UserGrader.GraderServer.get_users_with_minimum_points(users_list_quantity)

    render(conn, "get.json", users_and_timestamp)
  end
end
