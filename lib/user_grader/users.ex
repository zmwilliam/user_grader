defmodule UserGrader.Users do
  @doc """
  Users context
  """

  alias UserGrader.Repo
  alias UserGrader.User
  import Ecto.Query

  @spec list_users(non_neg_integer(), non_neg_integer()) :: [] | [User.t()]
  def list_users(points_gte, limit) do
    from(u in User,
      where: u.points >= ^points_gte,
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Update all users in database with a random number between min_points and max_points

  Returns the quantity of affected records
  """
  @spec update_all_users_with_random_points(non_neg_integer(), non_neg_integer()) ::
          non_neg_integer()
  def update_all_users_with_random_points(min_points, max_points)
      when is_integer(min_points) and is_integer(max_points) do
    now = NaiveDateTime.utc_now()

    {count_updated_entries, _} =
      update(User, [],
        set: [
          updated_at: ^now,
          points:
            fragment(
              "FLOOR(RANDOM() * (?::int - ?::int + 1) + ?::int)",
              ^max_points,
              ^min_points,
              ^min_points
            )
        ]
      )
      |> Repo.update_all([])

    count_updated_entries
  end
end
