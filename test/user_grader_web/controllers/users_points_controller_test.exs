defmodule UserGraderWeb.UsersPointsControllerTest do
  use UserGraderWeb.ConnCase

  import UserGrader.UsersFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /" do
    test "first request should return `nil` timestamp", %{conn: conn} do
      _pid = start_supervised!({UserGrader.GraderServer, []})
      conn = get(conn, Routes.users_points_path(conn, :get))
      assert %{"users" => [], "timestamp" => nil} = json_response(conn, 200)
    end

    test "should return users with points and timestamp", %{conn: conn} do
      _pid = start_supervised!({UserGrader.GraderServer, []})

      %{id: user_id_one} = user_fixtures!(%{points: 100})
      %{id: user_id_two} = user_fixtures!(%{points: 100})

      expected_users_response = [
        %{"id" => user_id_one, "points" => 100},
        %{"id" => user_id_two, "points" => 100}
      ]

      conn = get(conn, Routes.users_points_path(conn, :get))
      assert %{"users" => users_got, "timestamp" => nil} = json_response(conn, 200)
      assert_users(expected_users_response, users_got)

      conn = get(conn, Routes.users_points_path(conn, :get))

      assert %{
               "users" => users_got,
               "timestamp" => timestamp_got
             } = json_response(conn, 200)

      assert_timestamp_format(timestamp_got)
      assert {:ok, _valid_datetime} = NaiveDateTime.from_iso8601(timestamp_got)
      assert_users(expected_users_response, users_got)
    end
  end

  defp assert_users(expected, got) do
    assert ^expected = Enum.sort_by(got, &Map.get(&1, "id"))
  end

  defp assert_timestamp_format(timestamp_text) do
    # "YYYY-MM-DD HH:mm:SS"
    Regex.match?(~r/^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$/, timestamp_text)
  end
end

