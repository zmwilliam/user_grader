# UserGrader

Code challenge for Remote.io, specification can be found [here](https://www.notion.so/Backend-code-exercise-d7df215ccb6f4d87a3ef865506763d50)


# Running locally

## Prerequisites
 - Erlang 25.1
 - Elixir 1.14
 - Postgres 14

 If you use [asdf-vm](https://asdf-vm.com/), you can run to install the Erlang and Elixir versions on .tool-versions file
 ```sh
 $ asdf install
 ```

You can run a Postgres instance using docker with:
```sh
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:14-alpine
```

## To start your Phoenix server:

```sh
  # Install dependencies  
  $ mix deps.get

  # Create and migrate and seed your database  
  $ mix ecto.setup
  
  # Start Phoenix endpoint with 
  $ mix phx.server 
  # or inside IEx with 
  $ iex -S mix phx.server
  # or you can start with a different database URL
  $ DATABASE_URL=ecto://my_pg_user:my_password@localhost/user_grader_dev; mix phx.server
```

Now you can access the root endpoint `/` and it should return a json
```sh
  $ curl http://locahost:4000/
```

## Implementation commentary

For this project the main modules are:

`UserGrader.Users` is the context module responsible for fetching and updating `UserGrader.User` schema

`UserGrader.GraderServer` is the GenServer that:
  - Periodic updates `User` points at `handle_info(:perform_update_users_points, ...)`
  - Returns the list of Users and a Timestamp when `get_users_with_minimum_points/1` is called
  - Some configurations can be defined at `config/config.exs` -> `:user_grader, :grader_server`
    - `periodic_update_enabled`: when set to false disables the automatic updated for users points (default: true)
    - `periodic_update_interval_ms`: interval in milliseconds between user points updated (default: 60_000)
    - `minimum_points`: minimum points that can be set as a user points (default: 0),
    - `maximum_points`: maximum points that cen bet set as a user points (default: 100)
    
`UserGraderWeb.UsersPointsController` and `UserGraderWeb.UsersPointsView` are responsible to handle and answer the API calls to `/`, and return a json reponse as requested by the specification
