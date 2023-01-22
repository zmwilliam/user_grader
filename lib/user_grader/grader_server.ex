defmodule UserGrader.GraderServer do
  use GenServer

  require Logger

  alias UserGrader.Users

  @configs Application.compile_env!(:user_grader, :grader_server)

  @type t :: %__MODULE__{
          min_number: non_neg_integer(),
          timestamp: NaiveDateTime.t(),
          task_ref: reference()
        }
  defstruct min_number: 0, timestamp: nil, task_ref: nil

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_users_with_minimum_points(limit) do
    GenServer.call(__MODULE__, {:get_users_with_minimum_points, limit})
  end

  def init(_args) do
    initial_state = %__MODULE__{
      min_number: get_random(),
      timestamp: nil
    }

    if(is_task_enabled()) do
      send(self(), :perform_update_users_points)
    end

    {:ok, initial_state}
  end

  def handle_call({:get_users_with_minimum_points, limit}, _from, state) do
    %{min_number: min_number, timestamp: timestamp} = state

    users_found = Users.list_users(min_number, limit)

    updated_state = %__MODULE__{state | timestamp: NaiveDateTime.utc_now()}

    reply = %{
      users: users_found,
      previous_timestamp: timestamp
    }

    {:reply, reply, updated_state}
  end

  def handle_info(:perform_update_users_points, %{task_ref: ref} = state)
      when is_reference(ref) do
    Logger.debug("[GraderServer] updated users points already running")
    {:noreply, state}
  end

  def handle_info(:perform_update_users_points, %{task_ref: nil} = state) do
    task =
      Task.Supervisor.async_nolink(UserGrader.TaskSupervisor, fn ->
        Logger.debug("[GraderServer] update users points started")

        {time, _} =
          :timer.tc(fn ->
            Users.update_all_users_with_random_points(get_minimum_points(), get_maximum_points())
          end)

        Logger.debug("[GraderServer] update users points finished in #{us_to_ms(time)} ms")
      end)

    {:noreply, %__MODULE__{state | task_ref: task.ref}}
  end

  def handle_info({ref, _answer}, %{task_ref: ref} = state) do
    Logger.debug("[GraderServer] update users points completed successfully")

    Process.demonitor(ref, [:flush])

    updated_state = Map.merge(state, %{min_number: get_random(), task_ref: nil})

    {:noreply, updated_state, {:continue, :schedule_next_run}}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    Logger.error("[GraderServer] update users points failed, re-scheduling...")

    updated_state = %__MODULE__{state | task_ref: nil}

    {:noreply, updated_state, {:continue, :schedule_next_run}}
  end

  def handle_continue(:schedule_next_run, state) do
    schedule(get_task_interval())

    {:noreply, state}
  end

  defp schedule(interval) when interval > 0 do
    Process.send_after(self(), :perform_update_users_points, interval)
  end

  defp schedule(_non_neg_interval), do: false

  defp get_random() do
    Enum.random(get_minimum_points()..get_maximum_points())
  end

  defp us_to_ms(microseconds) do
    System.convert_time_unit(microseconds, :microsecond, :millisecond)
  end

  defp get_minimum_points(), do: Keyword.get(@configs, :minimum_points, 0)
  defp get_maximum_points(), do: Keyword.get(@configs, :maximum_points, 0)

  defp get_task_interval() do
    Keyword.get(@configs, :periodic_update_interval_ms, 0)
  end

  defp is_task_enabled() do
    Keyword.get(@configs, :periodic_update_enabled, false)
  end
end
