# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     UserGrader.Repo.insert!(%UserGrader.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias UserGrader.Repo

total_records = 1_000_000
chunk_size = 20_000

1..total_records
|> Stream.map(fn _ ->
  %{
    points: 0,
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  }
end)
|> Stream.chunk_every(chunk_size)
|> Stream.each(fn chunk -> Repo.insert_all("users", chunk) end)
|> Stream.run()
