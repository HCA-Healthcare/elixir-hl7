defmodule Hl7.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_hl7,
      version: String.trim(File.read!("./VERSION")),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        groups_for_modules: [
          "Version 2.1": ~r"HL7.V2_1.",
          "Version 2.2": ~r"HL7.V2_2.",
          "Version 2.3": ~r"HL7.V2_3.",
          "Version 2.3.1": ~r"HL7.V2_3_1.",
          "Version 2.4": ~r"HL7.V2_4.",
          "Version 2.5": ~r"HL7.V2_5.",
          "Version 2.5.1": ~r"Hl7.V2_5_1."
        ]
      ]
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
      {:benchee, "~> 0.13.1", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
