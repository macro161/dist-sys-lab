defmodule Login do

  def register(username, password) do
    PersistentLogin.register(username, password)
  end

  def login(username, password, device_id) do
    case CachedLogin.login(username, device_id) do
      :ok -> {:ok,:cached}
      _ -> handle_persistent_login(username, password, device_id)
    end
  end

  defp handle_persistent_login(username, password, device_id) do
    case PersistentLogin.login(username, password) do
      :ok ->
        CachedLogin.save_device_id(username, device_id)
        {:ok,:persistent}
      :no_user -> :no_user
      :wrong_password -> :wrong_password
      _ -> :error
    end
  end
end
