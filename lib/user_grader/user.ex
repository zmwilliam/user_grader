defmodule UserGrader.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :points, :integer

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:points])
    |> validate_required([:points])
  end
end
