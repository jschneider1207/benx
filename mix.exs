defmodule Benx.Mixfile do
  use Mix.Project

  def project do
    [app: :benx,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
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
