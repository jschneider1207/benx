defmodule Benx.Mixfile do
  use Mix.Project

  def project do
    [app: :benx,
     version: "0.1.2",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14.5", only: :dev}]
  end

  defp description do
    """
    A fast parser for the Bencoding spec.
    """
  end

  defp package do
    [name: :benx,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Sam Schneider"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/sschneider1207/benx"}]
  end
end
