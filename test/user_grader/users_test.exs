defmodule UserGrader.UsersTest do
  use ExUnit.Case, async: true
  use UserGrader.DataCase

  alias UserGrader.Users
  alias UserGrader.User

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

  describe "update_all_users_with_random_points/2" do
    test "raise when parameters are not integers" do
      assert_raise FunctionClauseError, fn ->
        Users.update_all_users_with_random_points("1", 100)
      end

      assert_raise FunctionClauseError, fn ->
        Users.update_all_users_with_random_points(1, "100")
      end
    end

    test "updates all users points" do
      %{id: id_user_one} = user_fixtures!(%{points: 1})
      %{id: id_user_two} = user_fixtures!(%{points: 100})

      assert 2 == Users.update_all_users_with_random_points(10, 10)

      assert %{points: 10} = Repo.get!(User, id_user_one)
      assert %{points: 10} = Repo.get!(User, id_user_two)
    end
  end
end
