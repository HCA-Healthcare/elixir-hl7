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
    hl7 = HL7.Examples.wikipedia_sample_hl7(version)

    hl7_msg =
      hl7
      |> HL7.Message.new()

    assert Kernel.match?(%HL7.Message{raw: ^hl7}, hl7_msg)
    assert hl7_msg.message_type == "ADT"
    assert hl7_msg.trigger_event == "A01"
    assert hl7_msg.facility == "XYZHospC"
    assert hl7_msg.hl7_version == version
    assert hl7_msg.message_date_time == "20060529090131-0500"
  end

  #  test "HL7 parsed from raw to lists" do
  #    hl7 = HL7.Examples.wikipedia_sample_hl7()
  #
  #    hl7_msg =
  #      hl7
  #      |> HL7.Message.make_lists()
  #
  #    assert Kernel.match?(%HL7.Message{status: :lists}, hl7_msg)
  #  end

  test "Wikipedia message roundtrip" do
    hl7 = HL7.Examples.wikipedia_sample_hl7()

    lists =
      hl7
      |> HL7.Message.parse()
      |> Map.get(:lists)

    roundtrip =
      HL7.Message.new(lists)
      |> to_string()

    assert roundtrip == hl7
  end
end
