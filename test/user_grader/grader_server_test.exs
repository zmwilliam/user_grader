defmodule UserGrader.GraderServerTest do
  use UserGrader.DataCase

  import UserGrader.UsersFixtures

  alias UserGrader.GraderServer

  describe "get_users_with_minimum_points/1" do
    test "returns empty list when no users found" do
      start_supervised!({GraderServer, []})

      assert %{
               users: [],
               previous_timestamp: nil
             } = GraderServer.get_users_with_minimum_points(10)

      %GraderServer{
        timestamp: new_timestamp,
        min_number: min_number
      } = :sys.get_state(GraderServer)

      assert new_timestamp != nil
      assert min_number >= 0
      assert min_number <= 100
    end

    test "returns users with points" do
      start_supervised!({GraderServer, []})
      GraderServer.get_users_with_minimum_points(0)

      user_one = user_fixtures!(%{points: 100})
      user_two = user_fixtures!(%{points: 100})
      _ = user_fixtures!(%{points: 100})

      assert %{
               previous_timestamp: previous_timestamp,
               users: users
             } = GraderServer.get_users_with_minimum_points(2)

      assert %NaiveDateTime{} = previous_timestamp
      assert [^user_one, ^user_two] = Enum.sort_by(users, & &1.id)

      %GraderServer{
        timestamp: timestamp,
        min_number: min_number
      } = :sys.get_state(GraderServer)

      assert min_number >= 0
      assert min_number <= 100

      assert :gt = NaiveDateTime.compare(timestamp, previous_timestamp)
    end
  end
end
