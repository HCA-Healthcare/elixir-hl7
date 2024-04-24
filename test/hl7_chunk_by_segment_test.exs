defmodule HL7.ChunkBySegmentTest do
  use ExUnit.Case

  import HL7

  test "can chunk HL7 map data into groups of segments based on the lead segment name" do
    chunks = HL7.Examples.nist_immunization_hl7() |> new!() |> chunk_by_lead_segment("ORC")
    counts = Enum.map(chunks, &Enum.count/1)
    assert [7, 2, 13] == counts
  end

  test "can chunk HL7 map data into groups of segments based on the lead segment name and keep non-matching prefix segments" do
    chunks =
      HL7.Examples.nist_immunization_hl7()
      |> new!()
      |> chunk_by_lead_segment("ORC", keep_prefix_segments: true)

    counts = Enum.map(chunks, &Enum.count/1)
    assert [2, 7, 2, 13] == counts
  end

  test "can chunk lists of map data into groups of segments based on the lead segment name" do
    chunks =
      HL7.Examples.nist_immunization_hl7()
      |> new!()
      |> get_segments()
      |> chunk_by_lead_segment("ORC")

    counts = Enum.map(chunks, &Enum.count/1)
    assert [7, 2, 13] == counts
  end
end
