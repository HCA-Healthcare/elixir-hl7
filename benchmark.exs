
alias Hl7.Message
alias Hl7.Examples

raw_msg = Examples.wikipedia_sample_hl7 |> Message.new()
lists_msg = Examples.wikipedia_sample_hl7 |> Message.make_lists()
structs_msg = Examples.wikipedia_sample_hl7 |> Message.make_structs()


Benchee.run(%{
  "new"          => fn -> Examples.wikipedia_sample_hl7 |> Message.new() end,
  "make_lists"   => fn -> Examples.wikipedia_sample_hl7 |> Message.make_lists() end,
  "make_structs" => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() end,
  "roundtrip"    => fn -> Examples.wikipedia_sample_hl7 |> Message.make_structs() |> Message.get_raw() end,
})


#original

#new                38.69 K       25.85 μs    ±35.78%          24 μs          55 μs
#make_lists          7.26 K      137.81 μs    ±16.76%         131 μs      248.60 μs
#make_structs        4.96 K      201.48 μs    ±17.41%         191 μs      339.22 μs
#roundtrip           3.74 K      267.48 μs    ±14.38%         258 μs         412 μs

# as of 6/14 (better list formats and struct safety if modified externally)

#new                45.53 K       21.96 μs    ±43.04%          20 μs          48 μs
#make_lists          8.45 K      118.38 μs    ±20.55%         111 μs         253 μs
#make_structs        6.15 K      162.54 μs    ±21.92%         148 μs         341 μs
#roundtrip           3.58 K      279.65 μs    ±21.12%         260 μs         579 μs


#Benchee.run(%{
#  "get_segment: from raw"      => fn -> raw_msg |> Message.get_segment("OBX") end,
#  "get_segment: from lists"    => fn -> lists_msg |> Message.get_segment("OBX") end,
#  "get_segment: from structs"  => fn -> structs_msg |> Message.get_segment("OBX") end,
#  "get_segments: from raw"     => fn -> raw_msg |> Message.get_segments("OBX") end,
#  "get_segments: from lists"   => fn -> lists_msg |> Message.get_segments("OBX") end,
#  "get_segments: from structs" => fn -> structs_msg |> Message.get_segments("OBX") end,
#})


#Benchee.run(%{
##  "get_part: list msg shallow" => fn -> lists_msg |> Message.get_part(0) end,
##  "get_part: list msg string shallow" => fn -> lists_msg |> Message.get_part("MSH") end,
#  "get_part: list msg deep" => fn -> lists_msg |> Message.get_part(4,6,0,1) end,
##  "get_part: list msg string deep" => fn -> lists_msg |> Message.get_part("OBX",6,0,1) end,
#
##  "get_value: list msg" => fn -> lists_msg |> Message.get_value(4) end,
#  "get_value: list msg deep" => fn -> lists_msg |> Message.get_value(4,6,0,1) end,
##  "get_part: struct msg shallow" => fn -> structs_msg |> Message.get_part(0) end,
##  "get_part: struct msg string shallow" => fn -> structs_msg |> Message.get_part("MSH") end,
#  "get_part: struct msg deep" => fn -> structs_msg |> Message.get_part(4,6,0,1) end,
#  "get_part: struct msg string deep" => fn -> structs_msg |> Message.get_part("OBX",6,0,1) end,
#  "get_part: struct msg atoms deep" => fn -> structs_msg |> Message.get_part("OBX",:units,0,:text) end,
##  "get_value: struct msg" => fn -> structs_msg |> Message.get_value(4) end,
#  "get_value: struct msg deep" => fn -> structs_msg |> Message.get_value(4,6,0,1) end,
#})
