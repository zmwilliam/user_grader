defmodule UserGraderWeb.UsersPointsView do
  use UserGraderWeb, :view

  def render("get.json", %{users: users, previous_timestamp: timestamp}) do
    %{
      users: Enum.map(users, &Map.take(&1, [:id, :points])),
      timestamp: format_timestamp(timestamp)
    }
  end

  defp format_timestamp(nil), do: nil

  defp format_timestamp(timestamp) do
    timestamp
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
