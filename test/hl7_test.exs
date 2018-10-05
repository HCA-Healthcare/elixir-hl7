defmodule HL7Test do
  use ExUnit.Case
  doctest HL7

  test "HL7 new message" do
    hl7 = HL7.Examples.wikipedia_sample_hl7()

    hl7_msg =
      hl7
      |> HL7.Message.new()

    assert Kernel.match?(%HL7.Message{status: :raw, content: ^hl7}, hl7_msg)
    assert hl7_msg.message_type == "ADT A01"
    assert hl7_msg.facility == "XYZHospC"
    assert hl7_msg.hl7_version == "2.5"
    assert hl7_msg.message_date_time == "20060529090131-0500"
  end

  test "HL7 parsed from raw to lists" do
    hl7 = HL7.Examples.wikipedia_sample_hl7()

    hl7_msg =
      hl7
      |> HL7.Message.make_lists()

    assert Kernel.match?(%HL7.Message{status: :lists}, hl7_msg)
  end

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
