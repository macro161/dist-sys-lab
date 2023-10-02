defmodule TwoFactorAuth.MixProject do
  use Mix.Project

  def project do
    [
      app: :two_factor_auth,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
      # releases: [
      #   dss: [include_executables_for: [:unix]]
      # ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MyApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:local_cluster, "~> 1.2"},
      {:syn, "~> 3.3"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.3"}
    ]
  end
end
