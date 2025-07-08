defmodule HL7.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_hl7,
      version: String.trim(File.read!("./VERSION")),
      description: "An Elixir library for working with HL7 v2.x healthcare data",
      source_url: github_link(),
      package: package(),
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [
          :error_handling,
          :underspecs,
          :unmatched_returns | conditional_dialyzer_flags(System.otp_release())
        ]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      aliases: aliases(),

      # Docs
      docs: [
        api_reference: false,
        extras: ["README.md"],
        main: "readme",
        groups_for_modules: [
          Deprecated: [
            HL7.FieldGrammar,
            HL7.InvalidGrammar,
            HL7.InvalidMessage,
            HL7.Message,
            HL7.Parser,
            HL7.PathParser,
            HL7.Query,
            HL7.RawMessage,
            HL7.Segment,
            HL7.Separators
          ]
        ],
        nest_modules_by_prefix: ["HL7"]
      ]
    ]
  end

  defp aliases() do
    [
      "parsec.compile": [
        "nimble_parsec.compile parsec_source/path_parser.ex.exs -o lib/hl7/path_parser.ex"
      ]
    ]
  end

  defp conditional_dialyzer_flags(otp_release) do
    case String.to_integer(otp_release) do
      x when x < 25 ->
        []

      _ ->
        [:missing_return, :extra_return]
    end
  end

  defp github_link() do
    "https://github.com/HCA-Healthcare/elixir-hl7"
  end

  defp package() do
    [
      name: "elixir_hl7",
      files: ~w(lib .formatter.exs mix.exs benchmark.exs README* LICENSE* VERSION*),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => github_link()},
      maintainers: ["Scott Southworth", "Bryan Hunter"]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.1.0", only: :dev},
      {:dialyxir, "~> 1.4.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.38.2", only: [:dev, :test], runtime: false},
      {:junit_formatter, "~> 3.3.1", only: :test},
      {:propcheck, "~> 1.4.1", only: [:test, :dev]},
      {:nimble_parsec, "~> 1.4.0", only: [:test, :dev], runtime: false},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
