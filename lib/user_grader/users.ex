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
end
