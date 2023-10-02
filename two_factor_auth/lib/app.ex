defmodule MyApp do
  use Application

  def start(_type, _args) do
    :ok = :syn.add_node_to_scopes([:cached_login, :persistent_login])

    children = [CachedLogin,PersistentLogin]
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
