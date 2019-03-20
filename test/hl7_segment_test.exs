defmodule HL7SegmentTest do
  use ExUnit.Case
  require Logger

  doctest HL7.Segment

  test "Can replace a segment field with a string" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "ZZZ", 0)
    segment_name = new_pid |> HL7.Segment.get_part(0)
    assert segment_name == "ZZZ"
  end

  test "Can inject a segment field" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "ZZZ", 20)
    v = new_pid |> HL7.Segment.get_part(20)
    assert v == "ZZZ"
  end

  test "Can inject a segment component" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "sub here", 3, 0, 1)
    v = new_pid |> HL7.Segment.get_part(3, 0, 1)
    assert v == "sub here"
  end

  test "Can inject a segment subcomponent" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "sub here", 3, 0, 1, 2)
    v = new_pid |> HL7.Segment.get_part(3, 0, 1, 2)
    assert v == "sub here"
  end

  test "Can replace a segment field with a list" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, [["sleep", "sleep", ["and", "more_sleep"]]], 1)
    v = new_pid |> HL7.Segment.get_part(1, 0, 2, 1)
    assert v == "more_sleep"
  end

  test "Can replace a segment field with a function" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, fn d -> d <> "X" end, 8)
    v = new_pid |> HL7.Segment.get_part(8)
    assert v == "MX"
  end

  test "Can replace a segment repetition" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "redacted", 11, 1)
    v = new_pid |> HL7.Segment.get_part(11, 1)
    assert v == "redacted"
  end

  test "Can inject a segment repetition" do
    pid =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.to_list()
      |> Enum.at(2)

    new_pid = HL7.Segment.replace_part(pid, "redacted", 11, 3)
    v = new_pid |> HL7.Segment.get_part(11, 3)
    assert v == "redacted"
  end
end
