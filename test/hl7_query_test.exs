defmodule HL7QueryTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Query
  import HL7.Query

  @wiki HL7.Examples.wikipedia_sample_hl7()

  # placed here for viewing convenience
  def wiki() do
    """
    MSH|^~\\&|MegaReg|XYZHospC|SuperOE|XYZImgCtr|20060529090131-0500||ADT^A01^ADT_A01|01052901|P|2.5
    EVN||200605290901||||200605290900
    PID|||56782445^^^UAReg^PI||KLEINSAMPLE^BARRY^Q^JR||19620910|M||2028-9^^HL70005^RA99113^^XYZ|260 GOODWIN CREST DRIVE^^BIRMINGHAM^AL^35209^^M~NICKELL’S PICKLES^10000 W 100TH AVE^BIRMINGHAM^AL^35200^^O|||||||0105I30001^^^99DEF^AN
    PV1||I|W^389^1^UABH^^^^3||||12345^MORGAN^REX^J^^^MD^0010^UAMC^L||67890^GRAINGER^LUCY^X^^^MD^0010^UAMC^L|MED|||||A0||13579^POTTER^SHERMAN^T^^^MD^0010^UAMC^L|||||||||||||||||||||||||||200605290900
    OBX|1|N^K&M|^Body Height||1.80|m^Meter^ISO+|||||F
    OBX|2|NM|^Body Weight||79|kg^Kilogram^ISO+|||||F
    AL1|1||^ASPIRIN
    DG1|1||786.50^CHEST PAIN, UNSPECIFIED^I9|||A
    """
    |> String.replace("\n", "\r")
  end

  test "query back to message" do
    m = select(@wiki) |> to_message() |> to_string
    assert m == @wiki
  end

  test "select one simple segment" do
    groups = select(@wiki, "MSH") |> get_segment_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 4) == "XYZHospC"
  end

  test "select multiple simple segments" do
    groups = select(@wiki, "OBX") |> get_segment_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 5) == "1.80"
  end

  test "select one segment group" do
    groups = select(@wiki, "OBX AL1 DG1") |> get_segment_groups()
    segments = groups |> List.first()
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select segment groups with optional segments" do
    groups = select(@wiki, "OBX {AL1} {DG1}") |> get_segment_groups()
    count = select(@wiki, "OBX {AL1} {DG1}") |> get_match_count()
    segments = groups |> Enum.at(1)
    segment = segments |> Enum.at(1)

    assert count == 2
    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select NO segments via groups with mismatch" do
    segments = select(@wiki, "OBX DG1") |> get_segment_groups()
    count = select(@wiki, "OBX DG1") |> get_match_count()
    assert segments == []
    assert count == 0
  end

  test "extract a segment field from the first segment" do
    part = select(@wiki) |> get_part("3")
    assert part == "MegaReg"
  end

  test "extract a segment field from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2")
    assert part ==  ["N", ["K", "M"]]
  end

  test "extract part of a segment repetition from the first named segment" do
    part = select(@wiki) |> get_part("PID-11[2].3")
    assert part ==  "BIRMINGHAM"
  end

  test "extract a segment component from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2.1")
    assert part ==  "N"
  end

  test "extract a segment subcomponent from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2.2.2")
    assert part ==  "M"
  end

  test "extract multiple segment parts at once" do
    part = select(@wiki) |> get_parts("OBX-6.2")
    assert part ==  ["Meter", "Kilogram"]
  end


#  test "extract a segment field from the first named segment" do
#    part = select(@wiki) |> get_part("OBX-2")
#    assert part ==  [["N"], ["K", "M"]]
#  end


  test "filter segment type by name" do
    segment_names = select(@wiki, "OBX {AL1} {DG1}") |> filter("OBX") |> get_segment_names()
    assert segment_names == ["OBX", "OBX"]
  end

  test "filter a list of segment types" do
    segment_names = select(@wiki, "OBX {AL1} {DG1}") |> filter(["OBX", "DG1"]) |> get_segment_names()
    assert segment_names == ["OBX", "OBX", "DG1"]
  end

  test "reject segment a type by name" do
    assert true
  end

  test "reject a list of segment types" do
    assert true
  end

  test "map a list of segment types" do
    assert true
  end
end
