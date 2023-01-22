defmodule UserGrader.UsersTest do
  use ExUnit.Case, async: true
  use UserGrader.DataCase

  alias UserGrader.Users

  import UserGrader.UsersFixtures

  describe "list_users/2" do
    test "returns users with minimum points" do
      user_fixtures!(%{points: 4})
      min_points = 5
      expected_users = for points <- min_points..10, do: user_fixtures!(%{points: points})

      assert ^expected_users = Users.list_users(min_points, 100) |> Enum.sort_by(& &1.id)
    end

    test "return limited records" do
      for p <- 1..10, do: user_fixtures!(%{points: p})

      assert [] = Users.list_users(0, 0)
      assert 2 == Users.list_users(0, 2) |> Enum.count()
      assert 5 == Users.list_users(0, 5) |> Enum.count()
    end
  end
end
