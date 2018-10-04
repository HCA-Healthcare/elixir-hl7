defmodule HL7Test do
  use ExUnit.Case
  doctest HL7

  test "Wikipedia message roundtrip" do
    hl7 = HL7.Examples.wikipedia_sample_hl7()

    roundtrip =
      hl7
      |> HL7.Message.new()
      |> HL7.Message.make_structs()
      |> to_string()

    assert roundtrip == hl7
  end
end
