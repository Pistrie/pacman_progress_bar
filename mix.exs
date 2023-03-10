defmodule PacmanProgressBar.MixProject do
  use Mix.Project

  @source_url "https://gitlab.com/Pistrie/pacman_progress_bar"

  def project do
    [
      app: :pacman_progress_bar,
      source_url: @source_url,
      version: "0.2.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      description:
        "Command-line progress bar in the style of Arch Linux's pacman package manager.",
      maintainers: ["Sylvester Roos"],
      licenses: ["LGPL-3.0-or-later"],
      links: %{"GitLab" => @source_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
