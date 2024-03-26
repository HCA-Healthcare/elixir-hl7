defmodule HL7.MapsTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Maps

  import HL7.Maps
  import HL7.HPath, only: :sigils

  # placed here for viewing convenience
  def wiki_text() do
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

  test "creates HL7 Maps (a list of maps) from HL7 text" do
    maps = new(wiki_text())
    assert is_list(maps)
    assert Enum.all?(maps, &is_map/1)
  end

  test "converts HL7 Maps to HL7 list data" do
    list = wiki_text() |> new() |> to_list()
    assert is_list(list)
    assert Enum.all?(list, &is_list/1)
  end

  test "can convert HL7 Maps back and forth to text" do
    converted = wiki_text() |> new() |> to_list() |> HL7.Message.new() |> to_string()
    assert converted == wiki_text()
  end

  test "can find segment as map" do
    segment_maps = wiki_text() |> new()
    pid = find(segment_maps, ~HP"PID")
    assert match?(%{0 => "PID", e: 18}, pid)
  end

  test "can find no segment as nil" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"ZZZ")
    assert is_nil(result)
  end

  test "can find multiple segments as list of maps" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[*]")
    assert match?([%{0 => "OBX", e: 11}, %{0 => "OBX", e: 11}], result)
  end

  test "can find lack of multiple segments as empty list" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"ZZZ[*]")
    assert [] == result
  end

  test "can find field as map" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID-11")

    assert %{
             1 => "260 GOODWIN CREST DRIVE",
             3 => "BIRMINGHAM",
             4 => "AL",
             5 => "35209",
             7 => "M",
             :e => 7
           } == result
  end

  test "can find repetition as map" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID-11[2]")

    assert %{
             1 => "NICKELL’S PICKLES",
             2 => "10000 W 100TH AVE",
             3 => "BIRMINGHAM",
             4 => "AL",
             5 => "35200",
             7 => "O",
             :e => 7
           } == result
  end

  test "can find all repetitions as list of maps" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID-11[*]")

    assert [
             %{
               1 => "260 GOODWIN CREST DRIVE",
               3 => "BIRMINGHAM",
               4 => "AL",
               5 => "35209",
               7 => "M",
               :e => 7
             },
             %{
               1 => "NICKELL’S PICKLES",
               2 => "10000 W 100TH AVE",
               3 => "BIRMINGHAM",
               4 => "AL",
               5 => "35200",
               7 => "O",
               :e => 7
             }
           ] == result
  end

  test "can find components in all repetitions as list of values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID-11[*].5")
    assert ["35209", "35200"] == result
  end

  test "can find components in all repetitions for all segments as a nested list of values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID[*]-11[*].5")
    assert [["35209", "35200"]] == result
  end

  test "can find components in one repetition" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"PID-11[2].5")
    assert "35200" == result
  end

  test "can find fields in multiple segments as list of values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[*]-5")
    assert ["1.80", "79"] == result
  end

  test "can find components in multiple segments as list of values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[*]-3.2")
    assert ["Body Height", "Body Weight"] == result
  end

  test "can find truncated results to return first position at any level" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[*]-2!")
    assert ["N", "NM"] == result
  end

  test "can find subcomponent values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX-2.2.1")
    assert "K" == result
  end

  test "can find from within specific segment numbers" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[2]-6.2")
    assert "Kilogram" == result
  end

  test "can return nil for missing values" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[2]-2.2.1")
    assert nil == result
  end

  test "can return nils for missing values in a list of returns" do
    segment_maps = wiki_text() |> new()
    result = find(segment_maps, ~HP"OBX[*]-2.2.1")
    assert ["K", nil] == result
  end

  test "can label source data using an output map template" do
    result = wiki_text() |> new() |> label(%{mrn: ~HP"PID-3!", name: ~HP"PID-5.2"})
    assert %{mrn: "56782445", name: "BARRY"} == result
  end

  test "can label source data using an output map template with functions" do
    fun = fn data -> find(data, ~HP"PID-5.2") end
    result = wiki_text() |> new() |> label(%{mrn: ~HP"PID-3!", name: fun})
    assert %{mrn: "56782445", name: "BARRY"} == result
  end

  test "can chunk map data into groups of segments based on the lead segment name" do
    chunks = HL7.Examples.nist_immunization_hl7() |> new() |> chunk_by_lead_segment("ORC")
    counts = Enum.map(chunks, &Enum.count/1)
    assert [7, 2, 13] == counts
  end
end
