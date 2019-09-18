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
