defmodule HL7.MessageTest do
  use ExUnit.Case
  require Logger

  doctest HL7.Message

  test "Can generate an Invalid Message Header" do
    header = %HL7.InvalidHeader{raw: "raw", reason: :unknown}
    assert header.raw == "raw"
    assert header.reason == :unknown
  end

  test "HL7 parse all versions" do
    ["2.1", "2.2", "2.3", "2.3.1", "2.4", "2.5", "2.5.1"]
    |> Enum.each(fn version ->
      make_example_message(version)
      make_header_message(version)
    end)
  end

  test "Create new roundtrip msh from header" do
    header = %HL7.Header{} = HL7.Header.new("ADT", "A04", "SAMPLE_ID")
    new_msg = HL7.Message.new(header)
    msh_from_msg = HL7.Message.to_list(new_msg) |> Enum.at(0)
    msh_from_header = HL7.Header.to_msh(header)

    assert msh_from_msg == msh_from_header
    assert new_msg.header.message_type == "ADT"
    assert new_msg.header.trigger_event == "A04"
    assert new_msg.header.message_control_id == "SAMPLE_ID"
  end

  test "Can build a Semi-Valid Message with Partial Header" do
    header = HL7.Header.new("ADT", "A04", "SAMPLE_ID") |> Map.put(:hl7_version, nil)
    new_msg = HL7.Message.new(header)
    msh_from_msg = HL7.Message.to_list(new_msg) |> Enum.at(0)
    msh_from_header = HL7.Header.to_msh(header)

    assert msh_from_msg == msh_from_header
    assert new_msg.header.message_type == "ADT"
    assert new_msg.header.trigger_event == "A04"
    assert new_msg.header.message_control_id == "SAMPLE_ID"
    assert new_msg.header.hl7_version == nil
  end

  test "Can generate an Invalid Message and Header from an invalid MSH" do
    header = %HL7.Header{} = HL7.Header.new("ADT", "A04", "SAMPLE_ID")
    new_msg = HL7.Message.new(header)
    msh_from_msg = HL7.Message.to_list(new_msg) |> Enum.at(0)
    bad_msh = msh_from_msg |> List.replace_at(9, "STUFF")

    bad_text =
      HL7.Message.to_list(new_msg)
      |> List.replace_at(0, bad_msh)
      |> HL7.Message.new()
      |> to_string()

    bad_msg = HL7.Message.new(bad_text)
    bad_header = bad_msg.header
    assert bad_header.reason == :invalid_message_type
  end

  test "Example HL7 roundtrips after going from new" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    roundtrip = raw_text |> HL7.Message.new() |> to_string()
    assert roundtrip == raw_text
  end

  test "Example HL7 roundtrips going from new -- with excess trailing text fragments" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    raw_text_with_garbage = raw_text <> "\rgarbage text"
    new_msg = raw_text_with_garbage |> HL7.Message.new()
    roundtrip = new_msg |> to_string()
    assert roundtrip == raw_text
    assert new_msg.fragments == [["garbage text"]]
  end

  test "Example HL7 roundtrips after going from raw" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    raw_msg = %HL7.RawMessage{} = HL7.Message.raw(raw_text)
    roundtrip = raw_msg |> to_string()
    assert roundtrip == raw_text
  end

  test "Example HL7 roundtrips after going from raw to new" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    roundtrip = raw_text |> HL7.Message.raw() |> HL7.Message.new() |> to_string()
    assert roundtrip == raw_text
  end

  test "Example HL7 roundtrips after going from new to raw" do
    raw_text = HL7.Examples.wikipedia_sample_hl7()
    roundtrip = raw_text |> HL7.Message.new() |> HL7.Message.raw() |> to_string()
    assert roundtrip == raw_text
  end

  test "A raw message passed into Message.raw returns itself" do
    raw = HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.raw()
    assert raw == HL7.Message.raw(raw)
  end

  test "A new message passed into Message.new returns itself" do
    new = HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.new()
    assert new == HL7.Message.new(new)
  end

  test "A message with truncation char works" do
    hl7 = HL7.Examples.elr_example()

    assert hl7 ==
             HL7.Examples.elr_example() |> HL7.Message.new() |> HL7.Message.raw() |> to_string()
  end

  test "A raw message can return its list of segments" do
    segment_count =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.raw()
      |> HL7.Message.to_list()
      |> Enum.count()

    assert segment_count == 8
  end

  test "A fast-path using Parser should return the same list structure as Message" do
    # currently, raw to new uses the Message split as opposed to Parser
    text = HL7.Examples.wikipedia_sample_hl7()
    orig_list = HL7.Message.raw(text) |> HL7.Message.to_list()
    parser_list = HL7.Parser.parse(text, nil, false)
    assert orig_list == parser_list
    parser_list_via_copy = HL7.Parser.parse(text, nil, true)
    assert orig_list == parser_list_via_copy
  end

  test "A list passed into Message.to_list returns itself" do
    segments = HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.raw() |> HL7.Message.to_list()
    assert segments == HL7.Message.to_list(segments)
  end

  test "A bogus message passed into Message.raw will result in InvalidMessage" do
    assert %HL7.InvalidMessage{} = HL7.Message.raw("Bogus message")
  end

  test "A bogus message passed into Message.new will result in InvalidMessage" do
    assert %HL7.InvalidMessage{} = HL7.Message.new("Bogus message")
  end

  test "A badly encoded message passed into Message.new will result in a Message without option `validate_string: true`" do
    latin1_text = <<220, 105, 178>>
    latin1_msg = HL7.Examples.wikipedia_sample_hl7() |> String.replace("A01", latin1_text)
    assert %HL7.Message{} = HL7.Message.new(latin1_msg)
  end

  test "A badly encoded message passed into Message.new will result in an InvalidMessage with option `validate_string: true`" do
    latin1_text = <<220, 105, 178>>
    latin1_msg = HL7.Examples.wikipedia_sample_hl7() |> String.replace("A01", latin1_text)
    assert %HL7.InvalidMessage{} = HL7.Message.new(latin1_msg, %{validate_string: true})
  end

  test "An incomplete header passed into Message.new will result in InvalidMessage" do
    missing_message_type =
      HL7.Examples.wikipedia_sample_hl7() |> String.replace("ADT^A01^ADT_A01", "")

    assert %HL7.InvalidMessage{} = HL7.Message.new(missing_message_type)
  end

  test "Can search a raw message for a segment name" do
    field_count =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.raw()
      |> HL7.Message.find("PID")
      |> Enum.count()

    assert field_count == 19
  end

  test "Can search a raw text for a segment name" do
    field_count =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.find("PID")
      |> Enum.count()

    assert field_count == 19
  end

  test "Can search a full message for a segment name" do
    field_count =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.new()
      |> HL7.Message.find("PID")
      |> Enum.count()

    assert field_count == 19
  end

  test "Can search a segment list for a segment name" do
    field_count =
      HL7.Examples.wikipedia_sample_hl7()
      |> HL7.Message.to_list()
      |> HL7.Message.find("PID")
      |> Enum.count()

    assert field_count == 19
  end

  test "Calling get_segments breaks a valid message into lists" do
    min_parsed = [
      [
        "MSH",
        "|",
        "^~\\&",
        "MegaReg",
        "XYZHospC",
        "SuperOE",
        "XYZImgCtr",
        "20060529090131-0500",
        "",
        [["ADT", "A01", "ADT_A01"]],
        "01052901",
        "P",
        "2.5"
      ],
      ["EVN", "", "200605290901", "", "", "", "200605290900"],
      [
        "PID",
        "",
        "",
        [["56782445", "", "", "UAReg", "PI"]],
        "",
        [["KLEINSAMPLE", "BARRY", "Q", "JR"]],
        "",
        "19620910",
        "M",
        "",
        [["2028-9", "", "HL70005", "RA99113", "", "XYZ"]],
        [
          ["260 GOODWIN CREST DRIVE", "", "BIRMINGHAM", "AL", "35209", "", "M"],
          ["NICKELL’S PICKLES", "10000 W 100TH AVE", "BIRMINGHAM", "AL", "35200", "", "O"]
        ],
        "",
        "",
        "",
        "",
        "",
        "",
        [["0105I30001", "", "", "99DEF", "AN"]]
      ],
      [
        "PV1",
        "",
        "I",
        [["W", "389", "1", "UABH", "", "", "", "3"]],
        "",
        "",
        "",
        [["12345", "MORGAN", "REX", "J", "", "", "MD", "0010", "UAMC", "L"]],
        "",
        [["67890", "GRAINGER", "LUCY", "X", "", "", "MD", "0010", "UAMC", "L"]],
        "MED",
        "",
        "",
        "",
        "",
        "A0",
        "",
        [["13579", "POTTER", "SHERMAN", "T", "", "", "MD", "0010", "UAMC", "L"]],
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "200605290900"
      ],
      [
        "OBX",
        "1",
        [["N", ["K", "M"]]],
        [["", "Body Height"]],
        "",
        "1.80",
        [["m", "Meter", "ISO+"]],
        "",
        "",
        "",
        "",
        "F"
      ],
      [
        "OBX",
        "2",
        "NM",
        [["", "Body Weight"]],
        "",
        "79",
        [["kg", "Kilogram", "ISO+"]],
        "",
        "",
        "",
        "",
        "F"
      ],
      ["AL1", "1", "", [["", "ASPIRIN"]]],
      ["DG1", "1", "", [["786.50", "CHEST PAIN, UNSPECIFIED", "I9"]], "", "", "A"]
    ]

    assert min_parsed == HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.to_list()
  end

  defp make_example_message(version) do
    raw_text = HL7.Examples.wikipedia_sample_hl7(version)
    hl7_msg = HL7.Message.new(raw_text)
    header = hl7_msg.header
    rebuilt_raw = hl7_msg |> to_string()
    assert rebuilt_raw == raw_text
    assert header.message_type == "ADT"
    assert header.trigger_event == "A01"
    assert header.sending_facility == "XYZHospC"
    assert header.hl7_version == version
    assert header.message_date_time == "20060529090131-0500"
  end

  defp make_header_message(version) do
    header = %HL7.Header{} = HL7.Header.new("ADT", "A04", "SAMPLE_ID", "P", version)
    hl7_msg = HL7.Message.new(header)
    hl7_msg_header = hl7_msg.header

    assert hl7_msg_header.message_type == "ADT"
    assert hl7_msg_header.trigger_event == "A04"
    assert hl7_msg_header.hl7_version == version
  end
end
