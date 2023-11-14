defmodule CachedLogin do
  use GenServer
  require Logger

  # Interface

  def login(username, device_id) do
    devices = GenServer.call(__MODULE__, :device_list)
    Logger.debug("Saved devices #{inspect(devices)}")
    stored_device_id = Map.get(devices, username)

    case stored_device_id do
      ^device_id -> :ok
      nil -> :no_user_or_device
      _ -> :wrong_device
    end
  end

  def save_device_id(username, device_id) do
    GenServer.cast(__MODULE__, {:store_device_id, username, device_id})
  end

  # Callbacks

  def init(_) do
    Logger.debug("Init CachedLogin")
    :ok = :syn.join(:cached_login, :node, self())
    {:ok, %{}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Sync
  def handle_call(:device_list, _from, state) do
    {:reply, state, state}
  end

  # Async
  def handle_cast({:store_device_id, username, device_id}, state) do
    members = for {pid, _} <- :syn.members(:cached_login, :node), do: pid

    if map_size(state) > 1 do
      members
      |> Enum.each(fn pid -> GenServer.cast(pid, {:replicate, %{username => device_id}}) end)

      {:noreply, %{username => device_id}}
    else
      members
      |> Enum.each(fn pid ->
        GenServer.cast(pid, {:replicate, Map.put(state, username, device_id)})
      end)

      {:noreply, Map.put(state, username, device_id)}
    end
  end

  def handle_cast({:replicate, state}, _) do
    {:noreply, state}
  end

  def handle_info(_info, state) do
    {:noreply, state}
  end

  # BROADCAST STARTS
  # state structure {map(username,device_id), initial_count, echo_count, ready_count}
  # default node count is 4

  def handle_cast({:broadcast, username, device_id}, state) do
    members = for {pid, _} <- :syn.members(:cached_login, :node), do: pid
    Map.put(state, username, device_id)

    members
    |> Enum.each(fn pid ->
      GenServer.cast(pid, :initial, {Map.put(state, username, device_id), 0, 0, 0})
    end)
  end

  def handle_cast({:initial}, state) do
    clients = elem(state, 0)
    initial = elem(state, 1) + 1
    echo = elem(state, 2)
    ready = elem(state, 3)

    cond do
      
    end
  end

  def handle_cast({:echo}, state) do
  end

  def handle_cast({:ready}, state) do
  end

  # BROADCAST ENDS
end
