defmodule UserGrader.UsersFixtures do
  def user_fixtures!(attrs \\ %{}) do
    attrs
    |> Enum.into(%{points: 0})
    |> UserGrader.User.changeset()
    |> UserGrader.Repo.insert!()
  end
end
