
alias Hl7.Message
alias Hl7.Examples

raw_msg = Examples.wikipedia_sample_hl7 |> Message.new()
lists_msg = Examples.wikipedia_sample_hl7 |> Message.make_lists()
structs_msg = Examples.wikipedia_sample_hl7 |> Message.make_structs()


#Benchee.run(%{
#  "new"          => fn -> Examples.wikipedia_sample_hl7 |> Message.new() end,
#  "make_lists"   => fn -> Examples.wikipedia_sample_hl7 |> Message.make_lists() end,
#  "make_structs" => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() end,
#  "roundtrip"    => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() |> Message.get_raw() end,
#})


#
#Benchee.run(%{
#  "get_segment: from raw"      => fn -> raw_msg |> Message.get_segment("OBX") end,
#  "get_segment: from lists"    => fn -> lists_msg |> Message.get_segment("OBX") end,
#  "get_segment: from structs"  => fn -> structs_msg |> Message.get_segment("OBX") end,
#  "get_segments: from raw"     => fn -> raw_msg |> Message.get_segments("OBX") end,
#  "get_segments: from lists"   => fn -> lists_msg |> Message.get_segments("OBX") end,
#  "get_segments: from structs" => fn -> structs_msg |> Message.get_segments("OBX") end,
#})

Benchee.run(%{
#  "get_part: list msg shallow" => fn -> lists_msg |> Message.get_part(0) end,
#  "get_part: list msg string shallow" => fn -> lists_msg |> Message.get_part("MSH") end,
#  "get_part: list msg deep" => fn -> lists_msg |> Message.get_part(4,6,0,1) end,
  "get_part: list msg string deep" => fn -> lists_msg |> Message.get_part(["OBX",6,0,1]) end,
  "get_part2: list msg string deep" => fn -> lists_msg |> Message.get_part2(["OBX",6,0,1]) end,

#  "get_value: list msg" => fn -> lists_msg |> Message.get_value(4) end,
#  "get_value: list msg deep" => fn -> lists_msg |> Message.get_value(4,6,0,1) end,
#  "get_part: struct msg shallow" => fn -> structs_msg |> Message.get_part(0) end,
#  "get_part: struct msg string shallow" => fn -> structs_msg |> Message.get_part("MSH") end,
#  "get_part: struct msg deep" => fn -> structs_msg |> Message.get_part(4,6,0,1) end,
#  "get_part: struct msg string deep" => fn -> structs_msg |> Message.get_part("OBX",6,0,1) end,
#  "get_part: struct msg atoms deep" => fn -> structs_msg |> Message.get_part("OBX",:units,0,:text) end,
#  "get_value: struct msg" => fn -> structs_msg |> Message.get_value(4) end,
#  "get_value: struct msg deep" => fn -> structs_msg |> Message.get_value(4,6,0,1) end,
})
