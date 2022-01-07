alias Benchee
alias HL7.Message
alias HL7.Examples

# raw_msg = Examples.wikipedia_sample_hl7 |> Message.raw()
# lists_msg = Examples.wikipedia_sample_hl7 |> Message.new()
# structs_msg = Examples.wikipedia_sample_hl7 |> Message.make_structs()

Benchee.run(%{
  "raw" => fn -> Examples.wikipedia_sample_hl7() |> Message.raw() end,
  "new" => fn -> Examples.wikipedia_sample_hl7() |> Message.new() end,
  "round-trip" => fn -> Examples.wikipedia_sample_hl7() |> Message.new() |> to_string() end
})

# Benchee.run(%{
#  "raw"          => fn -> Examples.nist_immunization_hl7() |> Message.raw() end,
#  "new"   => fn -> Examples.nist_immunization_hl7() |> Message.new() end,
#  "roundtrip"    => fn -> Examples.nist_immunization_hl7() |> Message.new() |> to_string() end,
# })

# raw = parsed header info, new = fully parsed, round-trip = fully parsed then back to text

# Name                ips        average  deviation         median         99th %

# with elixir 1.7.x

# raw             48.60 K       20.58 μs    ±38.76%          19 μs          42 μs
# new              8.73 K      114.54 μs    ±11.34%         111 μs         168 μs
# round-trip       6.17 K      162.17 μs    ±10.16%         159 μs      230.12 μs

# with erlang 22.0.7 and elixir 1.9.1

# raw              58.89 K       16.98 μs    ±54.32%          16 μs          37 μs
# new               8.91 K      112.26 μs    ±17.20%         108 μs         174 μs
# round-trip        6.49 K      154.11 μs    ±12.37%         151 μs         225 μs

# with erlang 24 elixir 1.12

# raw              61.83 K       16.17 μs    ±83.80%          15 μs          33 μs
# new               9.87 K      101.35 μs    ±15.06%          97 μs         150 μs
# round-trip        7.32 K      136.69 μs     ±9.41%         134 μs         191 μs

# with tokenized hot path for default parsing (~3x faster new!)

# raw              61.81 K       16.18 μs    ±52.61%       14.99 μs       37.99 μs
# new              27.54 K       36.31 μs    ±25.42%       32.99 μs       71.99 μs
# round-trip       14.90 K       67.13 μs    ±15.47%       64.99 μs      105.99 μs


