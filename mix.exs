defmodule HL7.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_hl7,
      version: String.trim(File.read!("./VERSION")),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:benchee, "~> 0.13.1", only: :dev}
    ]
  end
end
