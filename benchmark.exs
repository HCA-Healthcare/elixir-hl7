alias Benchee
alias HL7.Message
alias HL7.Examples

#raw_msg = Examples.wikipedia_sample_hl7 |> Message.raw()
#lists_msg = Examples.wikipedia_sample_hl7 |> Message.new()
#structs_msg = Examples.wikipedia_sample_hl7 |> Message.make_structs()


Benchee.run(%{
  "raw"          => fn -> Examples.wikipedia_sample_hl7() |> Message.raw() end,
  "new"   => fn -> Examples.wikipedia_sample_hl7() |> Message.new() end,
  "round-trip"    => fn -> Examples.wikipedia_sample_hl7() |> Message.new() |> to_string() end,
})

#Benchee.run(%{
#  "raw"          => fn -> Examples.nist_immunization_hl7() |> Message.raw() end,
#  "new"   => fn -> Examples.nist_immunization_hl7() |> Message.new() end,
#  "roundtrip"    => fn -> Examples.nist_immunization_hl7() |> Message.new() |> to_string() end,
#})

#original

#raw                38.69 K       25.85 μs    ±35.78%          24 μs          55 μs
#new          7.26 K      137.81 μs    ±16.76%         131 μs      248.60 μs
#structs        4.96 K      201.48 μs    ±17.41%         191 μs      339.22 μs
#roundtrip           3.74 K      267.48 μs    ±14.38%         258 μs         412 μs

# as of 6/14/18 (better list formats and struct safety if modified externally)

#raw                45.53 K       21.96 μs    ±43.04%          20 μs          48 μs
#new          8.45 K      118.38 μs    ±20.55%         111 μs         253 μs
#structs        6.15 K      162.54 μs    ±21.92%         148 μs         341 μs
#roundtrip           3.58 K      279.65 μs    ±21.12%         260 μs         579 μs

# as of 2/1/19 -- removed structs (thus also simplified roundtrip, bugs fixed)

# raw = parsed header info, new = fully parsed, round-trip = fully parsed then back to text

# Name                ips        average  deviation         median         99th %
# raw             48.60 K       20.58 μs    ±38.76%          19 μs          42 μs
# new              8.73 K      114.54 μs    ±11.34%         111 μs         168 μs
# round-trip        6.17 K      162.17 μs    ±10.16%         159 μs      230.12 μs

