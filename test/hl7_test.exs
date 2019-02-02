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
    rebuilt_raw = hl7_msg |> to_string()
    assert rebuilt_raw == raw_text
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

  test "Wikipedia parsed to minimal representation" do
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

    assert min_parsed == HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.get_segments()
  end
end
