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
    m = new(@wiki) |> to_message() |> to_string
    assert m == @wiki
  end

  test "select one simple segment" do
    groups = select(@wiki, "MSH") |> to_segment_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 4) == "XYZHospC"
  end

  test "select multiple simple segments" do
    groups = select(@wiki, "OBX") |> to_segment_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 5) == "1.80"
  end

  test "select one segment group" do
    groups = select(@wiki, "OBX AL1 DG1") |> to_segment_groups()
    segments = groups |> List.first()
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select segment groups with optional segments" do
    groups = select(@wiki, "OBX {AL1} {DG1}") |> to_segment_groups()
    count = select(@wiki, "OBX {AL1} {DG1}") |> to_match_count()
    segments = groups |> Enum.at(1)
    segment = segments |> Enum.at(1)

    assert count == 2
    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select NO segments via groups with mismatch" do
    segments = select(@wiki, "OBX DG1") |> to_segment_groups()
    count = select(@wiki, "OBX DG1") |> to_match_count()
    assert segments == []
    assert count == 0
  end

  test "filter segment a type by name" do
    assert true
  end

  test "filter a list of segment types" do
    assert true
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
