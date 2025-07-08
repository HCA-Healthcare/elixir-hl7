defmodule HL7.GetTest do
  use ExUnit.Case
  require Logger
  doctest HL7

  import HL7

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

  test "can get segment as map" do
    segment_maps = wiki_text() |> new!()
    pid = get(segment_maps, ~p"PID")
    assert match?(%{0 => "PID"}, pid)
  end

  test "can get data from a segment as map using partial path from segment" do
    pid = wiki_text() |> new!() |> get(~p"PID")
    assert "PI" == get(pid, ~p"3.5")
  end

  test "can get data from a segment as map using partial from repetition" do
    rep = wiki_text() |> new!() |> get(~p"PID-3")
    assert "PI" == get(rep, ~p".5")
  end

  test "can raise if partial path for field is run against full HL7" do
    msg = wiki_text() |> new!()
    assert_raise RuntimeError, fn -> get(msg, ~p"5") end
  end

  test "can raise if partial path for repetition is run against full segment" do
    pid = wiki_text() |> new!() |> get(~p"PID")
    assert_raise RuntimeError, fn -> get(pid, ~p".5") end
  end

  test "can get no segment as nil" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"ZZZ")
    assert is_nil(result)
  end

  test "can get multiple segments as list of maps" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[*]")
    assert match?([%{0 => "OBX"}, %{0 => "OBX"}], result)
  end

  test "can get lack of multiple segments as empty list" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"ZZZ[*]")
    assert [] == result
  end

  test "can get field as map (of 1st default repetition)" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID-11")

    assert %{
             1 => "260 GOODWIN CREST DRIVE",
             3 => "BIRMINGHAM",
             4 => "AL",
             5 => "35209",
             7 => "M"
           } == result
  end

  test "can get missing field as nil" do
    segment_maps = wiki_text() |> new!()
    assert nil == get(segment_maps, ~p"PID-25")
  end

  test "can get missing field as empty string with an exclamation path" do
    segment_maps = wiki_text() |> new!()
    assert "" == get(segment_maps, ~p"PID-25!")
  end

  test "can get repetition as map" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID-11[2]")

    assert %{
             1 => "NICKELL’S PICKLES",
             2 => "10000 W 100TH AVE",
             3 => "BIRMINGHAM",
             4 => "AL",
             5 => "35200",
             7 => "O"
           } == result
  end

  test "can get all repetitions as list of maps" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID-11[*]")

    assert [
             %{
               1 => "260 GOODWIN CREST DRIVE",
               3 => "BIRMINGHAM",
               4 => "AL",
               5 => "35209",
               7 => "M"
             },
             %{
               1 => "NICKELL’S PICKLES",
               2 => "10000 W 100TH AVE",
               3 => "BIRMINGHAM",
               4 => "AL",
               5 => "35200",
               7 => "O"
             }
           ] == result
  end

  test "can get all repetitions when field contains only a string" do
    assert ["M"] == wiki_text() |> new!() |> get(~p"PID-8[*]")
  end

  test "can get first repetitions or field as the same value when it contains only a string" do
    assert "M" = wiki_text() |> new!() |> get(~p"PID-8[1]")
    assert "M" = wiki_text() |> new!() |> get(~p"PID-8")
  end

  test "can get across a list of repetitions" do
    reps = wiki_text() |> new!() |> get(~p"PID-11[*]")
    assert ["35209", "35200"] == get(reps, ~p".5")
  end

  test "can get nothing across an empty list of repetitions" do
    assert [] == get([], ~p".5")
  end

  test "can get in a repetition" do
    rep = wiki_text() |> new!() |> get(~p"PID-11[2]")
    assert "35200" == get(rep, ~p".5")
  end

  test "can raise if getting a larger path directly against a repetition" do
    rep = wiki_text() |> new!() |> get(~p"PID-11[2]")
    assert_raise RuntimeError, fn -> get(rep, ~p"2.2") end
  end

  test "can get nil for missing component" do
    assert nil == wiki_text() |> new!() |> get(~p"PID-8.2")
  end

  test "can get components in all repetitions as list of values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID-11[*].5")
    assert ["35209", "35200"] == result
  end

  test "can get components in all repetitions for all segments as a nested list of values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID[*]-11[*].5")
    assert [["35209", "35200"]] == result
  end

  test "can get components in one repetition" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"PID-11[2].5")
    assert "35200" == result
  end

  test "can get fields in multiple segments as list of values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[*]-5")
    assert ["1.80", "79"] == result
  end

  test "can get components in multiple segments as list of values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[*]-3.2")
    assert ["Body Height", "Body Weight"] == result
  end

  test "can get truncated results to return first position at any level" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[*]-2!")
    assert ["N", "NM"] == result
  end

  test "can get subcomponent values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX-2.2.1")
    assert "K" == result
  end

  test "can get from within specific segment numbers" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[2]-6.2")
    assert "Kilogram" == result
  end

  test "can return nil for missing values" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[2]-2.2.1")
    assert nil == result
  end

  test "can return nils for missing values in a list of returns" do
    segment_maps = wiki_text() |> new!()
    result = get(segment_maps, ~p"OBX[*]-2.2.1")
    assert ["K", nil] == result
  end

  test "can get all message segments as maps" do
    result = wiki_text() |> new!() |> get_segments()

    assert [
             %{
               0 => "MSH",
               1 => "|",
               2 => "^~\\&",
               3 => "MegaReg",
               4 => "XYZHospC",
               5 => "SuperOE",
               6 => "XYZImgCtr",
               7 => "20060529090131-0500",
               9 => %{1 => %{1 => "ADT", 2 => "A01", 3 => "ADT_A01"}},
               10 => "01052901",
               11 => "P",
               12 => "2.5"
             },
             %{0 => "EVN", 2 => "200605290901", 6 => "200605290900"},
             %{
               0 => "PID",
               3 => %{1 => %{1 => "56782445", 4 => "UAReg", 5 => "PI"}},
               5 => %{1 => %{1 => "KLEINSAMPLE", 2 => "BARRY", 3 => "Q", 4 => "JR"}},
               7 => "19620910",
               8 => "M",
               10 => %{1 => %{1 => "2028-9", 3 => "HL70005", 4 => "RA99113", 6 => "XYZ"}},
               11 => %{
                 1 => %{
                   1 => "260 GOODWIN CREST DRIVE",
                   3 => "BIRMINGHAM",
                   4 => "AL",
                   5 => "35209",
                   7 => "M"
                 },
                 2 => %{
                   1 => "NICKELL’S PICKLES",
                   2 => "10000 W 100TH AVE",
                   3 => "BIRMINGHAM",
                   4 => "AL",
                   5 => "35200",
                   7 => "O"
                 }
               },
               18 => %{1 => %{1 => "0105I30001", 4 => "99DEF", 5 => "AN"}}
             },
             %{
               0 => "PV1",
               2 => "I",
               3 => %{1 => %{1 => "W", 2 => "389", 3 => "1", 4 => "UABH", 8 => "3"}},
               7 => %{
                 1 => %{
                   1 => "12345",
                   2 => "MORGAN",
                   3 => "REX",
                   4 => "J",
                   7 => "MD",
                   8 => "0010",
                   9 => "UAMC",
                   10 => "L"
                 }
               },
               9 => %{
                 1 => %{
                   1 => "67890",
                   2 => "GRAINGER",
                   3 => "LUCY",
                   4 => "X",
                   7 => "MD",
                   8 => "0010",
                   9 => "UAMC",
                   10 => "L"
                 }
               },
               10 => "MED",
               15 => "A0",
               17 => %{
                 1 => %{
                   1 => "13579",
                   2 => "POTTER",
                   3 => "SHERMAN",
                   4 => "T",
                   7 => "MD",
                   8 => "0010",
                   9 => "UAMC",
                   10 => "L"
                 }
               },
               44 => "200605290900"
             },
             %{
               0 => "OBX",
               1 => "1",
               2 => %{1 => %{1 => "N", 2 => %{1 => "K", 2 => "M"}}},
               3 => %{1 => %{2 => "Body Height"}},
               5 => "1.80",
               6 => %{1 => %{1 => "m", 2 => "Meter", 3 => "ISO+"}},
               11 => "F"
             },
             %{
               0 => "OBX",
               1 => "2",
               2 => "NM",
               3 => %{1 => %{2 => "Body Weight"}},
               5 => "79",
               6 => %{1 => %{1 => "kg", 2 => "Kilogram", 3 => "ISO+"}},
               11 => "F"
             },
             %{0 => "AL1", 1 => "1", 3 => %{1 => %{2 => "ASPIRIN"}}},
             %{
               0 => "DG1",
               1 => "1",
               3 => %{1 => %{1 => "786.50", 2 => "CHEST PAIN, UNSPECIFIED", 3 => "I9"}},
               6 => "A"
             }
           ] ==
             result
  end

  test "can set all message segments as maps" do
    hl7 = wiki_text() |> new!()
    segments = hl7 |> get_segments() |> Enum.take(2)
    updated_hl7 = set_segments(hl7, segments)
    updated_segments = get_segments(updated_hl7)

    assert [
             %{
               0 => "MSH",
               1 => "|",
               2 => "^~\\&",
               3 => "MegaReg",
               4 => "XYZHospC",
               5 => "SuperOE",
               6 => "XYZImgCtr",
               7 => "20060529090131-0500",
               9 => %{1 => %{1 => "ADT", 2 => "A01", 3 => "ADT_A01"}},
               10 => "01052901",
               11 => "P",
               12 => "2.5"
             },
             %{0 => "EVN", 2 => "200605290901", 6 => "200605290900"}
           ] == updated_segments
  end
end
