defmodule PersistentLogin do
  use GenServer
  require Logger

  # Interface

  def register(username, password) do
    GenServer.cast(__MODULE__, {:register, username, password})
  end

  def login(username, password) do
    users = GenServer.call(__MODULE__, :users_list)
    stored_password = Map.get(users, username)
    Logger.debug("#{inspect(users)}, #{username}, #{password}, #{stored_password}")

    case stored_password do
        ^password -> :ok
        nil -> :no_user
        _ -> :wrong_password
    end
  end

  # Callbacks
  def init(_) do
    Logger.debug("Init PersistentLogin")
    :ok = :syn.join(:persistent_login, :node, self())
    {:ok, %{}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Sync
  def handle_call(:users_list, _from, state) do
    {:reply, state, state}
  end

  # Async
  def handle_cast({:register, username, password}, state) do
    {:noreply, Map.put(state, username, password)}
  end

  def handle_info(_info, state) do
    {:no_reply, state}
  end

end
