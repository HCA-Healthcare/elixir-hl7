defmodule HL7Test do
  use ExUnit.Case
  use ExUnitProperties

  doctest HL7

  property "HL7 parse all versions" do
    check all version <-
                StreamData.member_of(["2.1", "2.2", "2.3", "2.3.1", "2.4", "2.5", "2.5.1"]) do
      make_example_message(version)
    end
  end

  defp make_example_message(version) do
    raw_text = HL7.Examples.wikipedia_sample_hl7(version)
    hl7_msg = HL7.Message.new(raw_text)
    header = hl7_msg.header

    assert hl7_msg.raw == raw_text
    assert header.message_type == "ADT"
    assert header.trigger_event == "A01"
    assert header.sending_facility == "XYZHospC"
    assert header.hl7_version == version
    assert header.message_date_time == "20060529090131-0500"
  end

  test "Wikipedia message roundtrip" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    roundtrip = HL7.Message.new(raw_text) |> HL7.Message.raw() |> to_string()
    assert roundtrip == raw_text
  end
end
