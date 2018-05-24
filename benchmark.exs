
alias Hl7.Message
alias Hl7.Examples

Benchee.run(%{
  "new"          => fn -> Examples.wikipedia_sample_hl7 |> Message.new() end,
  "make_lists"   => fn -> Examples.wikipedia_sample_hl7 |> Message.make_lists() end,
  "make_structs" => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() end,
  "roundtrip"    => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() |> Message.get_raw() end,
})
