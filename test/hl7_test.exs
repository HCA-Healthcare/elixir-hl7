defmodule HL7Test do
  use ExUnit.Case

  import HL7.TempFileCase
  use HL7.TempFileCase

  # ^K - VT (Vertical Tab) - 0x0B
  @sb "\v"
  # ^\ - FS (File Separator)
  @eb <<0x1C>>
  # ^M - CR (Carriage Return) - 0x0D
  @cr "\r"
  @ending @eb <> @cr

  @wiki_text HL7.Examples.wikipedia_sample_hl7()

  doctest HL7
  import HL7

  describe "HL7.get/2" do
    test "can get segment as map" do
      segment_maps = @wiki_text |> new!()
      pid = get(segment_maps, ~p"PID")
      assert match?(%{0 => "PID"}, pid)
    end

    test "can get data from a segment as map using partial path from segment" do
      pid = @wiki_text |> new!() |> get(~p"PID")
      assert "PI" == get(pid, ~p"3.5")
    end

    test "can get data from a segment as map using partial from repetition" do
      rep = @wiki_text |> new!() |> get(~p"PID-3")
      assert "PI" == get(rep, ~p".5")
    end

    test "can get field data if run against full HL7" do
      msg = @wiki_text |> new!()
      assert ["SuperOE", "", "KLEINSAMPLE", "", "1.80", "79", nil, ""] == get(msg, ~p"5!")
    end

    test "can get filter data by segment if run against selection of segments" do
      segments = @wiki_text |> new!() |> get_segments()
      assert ["1.80", "79"] == get(segments, ~p"OBX[*]-5!")
    end

    test "can get field data if run against selection of segments" do
      segments = @wiki_text |> new!() |> get_segments() |> Enum.take(3)
      assert ["SuperOE", "", "KLEINSAMPLE"] == get(segments, ~p"5!")
    end

    test "can get component data if run against selection of segments" do
      segments = @wiki_text |> new!() |> get_segments()
      assert [nil, nil, nil, nil, "K", nil, nil, nil] == get(segments, ~p"2.2!")
    end

    test "can raise if partial path for repetition is run against full segment" do
      pid = @wiki_text |> new!() |> get(~p"PID")
      assert_raise RuntimeError, fn -> get(pid, ~p".5") end
    end

    test "can get no segment as nil" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"ZZZ")
      assert is_nil(result)
    end

    test "can get multiple segments as list of maps" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[*]")
      assert match?([%{0 => "OBX"}, %{0 => "OBX"}], result)
    end

    test "can get lack of multiple segments as empty list" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"ZZZ[*]")
      assert [] == result
    end

    test "can get field as map (of 1st default repetition)" do
      segment_maps = @wiki_text |> new!()
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
      segment_maps = @wiki_text |> new!()
      assert nil == get(segment_maps, ~p"PID-25")
    end

    test "can get missing field as nil with an exclamation path" do
      segment_maps = @wiki_text |> new!()
      assert nil == get(segment_maps, ~p"PID-25!")
    end

    test "can get repetition as map" do
      segment_maps = @wiki_text |> new!()
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
      segment_maps = @wiki_text |> new!()
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
      assert ["M"] == @wiki_text |> new!() |> get(~p"PID-8[*]")
    end

    test "can get first repetitions or field as the same value when it contains only a string" do
      assert "M" = @wiki_text |> new!() |> get(~p"PID-8[1]")
      assert "M" = @wiki_text |> new!() |> get(~p"PID-8")
    end

    test "can get across a list of repetitions" do
      reps = @wiki_text |> new!() |> get(~p"PID-11[*]")
      assert ["35209", "35200"] == get(reps, ~p".5")
    end

    test "can get nothing across an empty list of repetitions" do
      assert [] == get([], ~p".5")
    end

    test "can get in a repetition" do
      rep = @wiki_text |> new!() |> get(~p"PID-11[2]")
      assert "35200" == get(rep, ~p".5")
    end

    test "can raise if getting a larger path directly against a repetition" do
      rep = @wiki_text |> new!() |> get(~p"PID-11[2]")
      assert_raise RuntimeError, fn -> get(rep, ~p"2.2") end
    end

    test "can get nil for missing component" do
      assert nil == @wiki_text |> new!() |> get(~p"PID-8.2")
    end

    test "can get components in all repetitions as list of values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"PID-11[*].5")
      assert ["35209", "35200"] == result
    end

    test "can get components in all repetitions for all segments as a nested list of values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"PID[*]-11[*].5")
      assert [["35209", "35200"]] == result
    end

    test "can get components in one repetition" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"PID-11[2].5")
      assert "35200" == result
    end

    test "can get fields in multiple segments as list of values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[*]-5")
      assert ["1.80", "79"] == result
    end

    test "can get components in multiple segments as list of values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[*]-3.2")
      assert ["Body Height", "Body Weight"] == result
    end

    test "can get truncated results to return first position at any level" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[*]-2!")
      assert ["N", "NM"] == result
    end

    test "can get subcomponent values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX-2.2.1")
      assert "K" == result
    end

    test "can get from within specific segment numbers" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[2]-6.2")
      assert "Kilogram" == result
    end

    test "can return nil for missing values" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[2]-2.2.1")
      assert nil == result
    end

    test "can return nils for missing values in a list of returns" do
      segment_maps = @wiki_text |> new!()
      result = get(segment_maps, ~p"OBX[*]-2.2.1")
      assert ["K", nil] == result
    end

    test "can get all message segments as maps" do
      result = @wiki_text |> new!() |> get_segments()

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
      hl7 = @wiki_text |> new!()
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

  describe "HL7.put/2" do
    test "can put field data as string" do
      msg = @wiki_text |> new!() |> put(~p"PID-8", "F")
      assert "F" == get(msg, ~p"PID-8")
    end

    test "can put field data as string while keeping simple internal format unchanged" do
      msg = @wiki_text |> new!() |> put(~p"PID-8", "F")
      pid = msg.segments |> Enum.at(2)
      assert "F" == pid[8]
    end

    test "can fail to put field data when segment does not exist" do
      msg = @wiki_text |> new!()
      assert_raise RuntimeError, fn -> put(msg, ~p"ZZZ-8", "F") end
    end

    test "can put field data as string overwriting map" do
      msg = @wiki_text |> new!() |> put(~p"PID-3", "SOME_ID")
      assert "SOME_ID" == get(msg, ~p"PID-3")
    end

    test "can put field data as string overwriting map of repetitions" do
      msg = @wiki_text |> new!() |> put(~p"PID-11[*]", "SOME_ID")
      assert ["SOME_ID"] == get(msg, ~p"PID-11[*]")
    end

    test "can put field data as repetition map overwriting repetitions" do
      msg =
        @wiki_text
        |> new!()
        |> put(~p"PID-11[*]", %{1 => "SOME_ID", 2 => "OTHER_ID", 3 => "FINAL_ID"})

      assert ["SOME_ID", "OTHER_ID", "FINAL_ID"] == get(msg, ~p"PID-11[*]")
    end

    test "can put field data as a list overwriting repetitions" do
      msg =
        @wiki_text
        |> new!()
        |> put(~p"PID-11[*]", ["SOME_ID", "OTHER_ID", "FINAL_ID"])

      assert ["SOME_ID", "OTHER_ID", "FINAL_ID"] == get(msg, ~p"PID-11[*]")
    end

    test "can put field data as map overwriting map" do
      map = %{1 => "123", 4 => "XX", 5 => "BB"}
      msg = @wiki_text |> new!() |> put(~p"PID-3", map)
      assert map == get(msg, ~p"PID-3")
    end

    test "can put repetition data as map overwriting map" do
      map = %{1 => "123", 4 => "XX", 5 => "BB"}
      msg = @wiki_text |> new!() |> put(~p"PID-3[1]", map)
      assert map == get(msg, ~p"PID-3[1]")
    end

    test "can put repetition data as map extending map" do
      map = %{1 => "123", 4 => "XX", 5 => "BB"}
      msg = @wiki_text |> new!() |> put(~p"PID-3[2]", map)
      assert map == get(msg, ~p"PID-3[2]")
    end

    test "can put repetition data across multiple components" do
      msg = @wiki_text |> new!() |> put(~p"PID-11[*].3", "SOME_PLACE")
      assert ["SOME_PLACE", "SOME_PLACE"] == get(msg, ~p"PID-11[*].3")
    end

    test "can put repetition data across multiple subcomponents" do
      msg = @wiki_text |> new!() |> put(~p"PID-11[*].3.2", "SOME_PLACE")
      assert ["SOME_PLACE", "SOME_PLACE"] == get(msg, ~p"PID-11[*].3.2")
    end

    test "can put repetition data across multiple components with partial path" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"11[*].3", "SOME_PLACE")
      assert ["SOME_PLACE", "SOME_PLACE"] == get(pid, ~p"11[*].3")
    end

    test "can put repetition data across multiple subcomponents with partial path" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"11[*].3.2", "SOME_PLACE")
      assert ["SOME_PLACE", "SOME_PLACE"] == get(pid, ~p"11[*].3.2")
    end

    test "can put data in a segment using partial path to field" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3")
    end

    test "can put data in a segment using partial path to repetition" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3[2]", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3[2]")
    end

    test "can put data in a segment using partial path to component" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3.2", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3.2")
    end

    test "can put data in a segment using partial path to subcomponent" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3.2.4", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3.2.4")
    end

    test "can put data in a segment using partial path to repetition and component" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3[2].2", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3[2].2")
    end

    test "can put data in a segment using partial path to repetition and subcomponent" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> put(~p"3[1].2.4", "SOME_ID")
      assert "SOME_ID" == get(pid, ~p"3[1].2.4")
    end

    test "can put component data in a string field" do
      msg = @wiki_text |> new!() |> put(~p"PID-8.2", "EXTRA")
      assert "EXTRA" == get(msg, ~p"PID-8.2")
      assert "M" == get(msg, ~p"PID-8.1")
    end

    test "can put data across multiple segments" do
      msg = @wiki_text |> new!() |> put(~p"OBX[*]-5", "REDACTED")
      assert ["REDACTED", "REDACTED"] == get(msg, ~p"OBX[*]-5")
    end

    test "can put across a list of repetitions" do
      reps = @wiki_text |> new!() |> get(~p"PID-11[*]")
      assert ["REDACTED", "REDACTED"] == put(reps, ~p".2", "REDACTED") |> get(~p".2")
    end

    test "can put in a repetition" do
      rep = @wiki_text |> new!() |> get(~p"PID-11[2]")
      assert "REDACTED" == put(rep, ~p".2", "REDACTED") |> get(~p".2")
    end

    test "can raise if putting a larger path directly against a repetition" do
      rep = @wiki_text |> new!() |> get(~p"PID-11[2]")
      assert_raise RuntimeError, fn -> put(rep, ~p"2.2", "REDACTED") end
    end
  end

  describe "HL7.update/4" do
    test "can update field data as string" do
      msg = @wiki_text |> new!() |> update(~p"PID-8", "F", fn data -> data <> "F" end)
      assert "MF" == get(msg, ~p"PID-8")
    end

    test "can update missing field data as string via default" do
      msg = @wiki_text |> new!() |> update(~p"PID-21", "X", fn data -> data <> "F" end)
      assert "X" == get(msg, ~p"PID-21")
    end

    test "can update field data as string overwriting map" do
      msg = @wiki_text |> new!() |> update(~p"PID-3", "SOME_ID", fn data -> data[1] <> "-X" end)
      assert "56782445-X" == get(msg, ~p"PID-3")
    end

    test "can update field data as list overwriting all repetitions" do
      msg =
        @wiki_text |> new!() |> update(~p"PID-11[*]", "SOME_ID", fn data -> data ++ ["123"] end)

      assert ["260 GOODWIN CREST DRIVE", "NICKELL’S PICKLES", "123"] == get(msg, ~p"PID-11[*].1")
    end

    test "can update field data as empty list overwriting all repetitions" do
      msg =
        @wiki_text |> new!() |> update(~p"PID-11[*]", [], fn _data -> [] end)

      assert [""] == get(msg, ~p"PID-11[*].1")
    end

    test "can update field data as empty string overwriting all repetitions" do
      msg =
        @wiki_text |> new!() |> update(~p"PID-11[*]", "", fn _data -> "" end)

      assert [""] == get(msg, ~p"PID-11[*].1")
    end

    test "can update field data as nil overwriting all repetitions" do
      msg =
        @wiki_text |> new!() |> update(~p"PID-11[*]", nil, fn _data -> nil end)
      assert [""] == get(msg, ~p"PID-11[*].1")
    end

    test "can update missing field data as list with" do
      msg =
        @wiki_text |> new!() |> update(~p"PID-20[*]", "SOME_ID", fn data -> data ++ ["123"] end)

      assert ["SOME_ID"] == get(msg, ~p"PID-20[*].1")
    end

    test "can update field data within a map" do
      msg = @wiki_text |> new!() |> update(~p"PID-3", nil, fn data -> Map.put(data, 1, "123") end)
      assert %{1 => "123", 4 => "UAReg", 5 => "PI"} == get(msg, ~p"PID-3")
    end

    test "can update repetition data within map" do
      msg = @wiki_text |> new!() |> update(~p"PID-3[1]", nil, &put(&1, ~p".2", "345"))
      assert "345" == get(msg, ~p"PID-3[1].2")
    end

    test "can update repetition data across multiple components" do
      msg = @wiki_text |> new!() |> update(~p"PID-11[*].3", nil, fn c -> c <> "2" end)
      assert ["BIRMINGHAM2", "BIRMINGHAM2"] == get(msg, ~p"PID-11[*].3")
    end

    test "can update repetition data across multiple components when the target is a string" do
      msg = @wiki_text |> new!() |> update(~p"EVN-2[*].3", "123", fn _ -> "345" end)
      assert ["123"] == get(msg, ~p"EVN-2[*].3")
    end

    test "can update repetition data across multiple components when the target is a string to be changed" do
      msg = @wiki_text |> new!() |> update(~p"EVN-2[*].1", "123", fn _ -> "345" end)
      assert ["345"] == get(msg, ~p"EVN-2[*].1")
    end

    test "can update repetition data across multiple components with partial path" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> update(~p"11[*].3", nil, fn c -> c <> "3" end)
      assert ["BIRMINGHAM3", "BIRMINGHAM3"] == get(pid, ~p"11[*].3")
    end

    test "can update data in a segment using partial path to field" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> update(~p"3", nil, fn f -> f[5] <> "4" end)
      assert "PI4" == get(pid, ~p"3")
    end

    test "can update data in a segment using partial path to repetition" do
      pid =
        @wiki_text |> new!() |> get(~p"PID") |> update(~p"11[2]", nil, fn f -> f[3] <> "4" end)

      assert "BIRMINGHAM4" == get(pid, ~p"11[2]")
    end

    test "can update data in a segment using partial path to component" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> update(~p"11.4", nil, fn c -> c <> "5" end)
      assert "AL5" == get(pid, ~p"11.4")
    end

    test "can update data in a segment using partial path to subcomponent" do
      obx = @wiki_text |> new!() |> get(~p"OBX") |> update(~p"2.2.2", nil, fn s -> s <> "6" end)
      assert "M6" == get(obx, ~p"2.2.2")
    end

    test "can update data in a segment using partial path to repetition and component" do
      pid = @wiki_text |> new!() |> get(~p"PID") |> update(~p"11[2].3", nil, fn c -> c <> "6" end)
      assert "BIRMINGHAM6" == get(pid, ~p"11[2].3")
    end

    test "can update data in a segment using partial path to repetition and subcomponent" do
      obx =
        @wiki_text |> new!() |> get(~p"OBX") |> update(~p"2[1].2.2", nil, fn s -> s <> "7" end)

      assert "M7" == get(obx, ~p"2[1].2.2")
    end

    test "can update component data in a string field" do
      msg = @wiki_text |> new!() |> update(~p"OBX-2.1", nil, fn c -> c <> "8" end)
      assert "N8" == get(msg, ~p"OBX-2.1")
    end

    test "can update data across multiple segments" do
      msg = @wiki_text |> new!() |> update(~p"OBX[*]-5", nil, fn f -> f <> " REDACTED" end)
      assert ["1.80 REDACTED", "79 REDACTED"] == get(msg, ~p"OBX[*]-5")
    end

    test "can update full segments across multiple segments" do
      msg =
        @wiki_text
        |> new!()
        |> update(~p"OBX[*]", nil, fn s -> HL7.put(s, ~p"4", HL7.get(s, ~p"5") <> " JUNK") end)

      assert ["1.80 JUNK", "79 JUNK"] == get(msg, ~p"OBX[*]-4")
    end

    test "can update missing data across multiple segments with default values" do
      msg = @wiki_text |> new!() |> update(~p"OBX[*]-15", "JUNK", fn f -> f <> " REDACTED" end)
      assert ["JUNK", "JUNK"] == get(msg, ~p"OBX[*]-15")
    end
  end

  describe "HL7.update!/3" do
    test "can update! data without default values" do
      msg = @wiki_text |> new!() |> update!(~p"PID-11[*].3", fn c -> c <> "2" end)
      assert ["BIRMINGHAM2", "BIRMINGHAM2"] == get(msg, ~p"PID-11[*].3")
    end

    test "can fail to update! data with missing values" do
      msg = @wiki_text |> new!()
      assert_raise KeyError, fn -> update!(msg, ~p"PID-11[*].2", fn c -> c <> "2" end) end
    end
  end

  describe "HL7 inspect protocol" do
    test "can inspect an HL7 message struct (long version)" do
      assert "#HL7<with 8 segments>" ==
               @wiki_text |> new!() |> inspect()
    end

    test "can inspect an HL7 message struct (short version)" do
      assert "#HL7<with 1 segment>" ==
               @wiki_text
               |> String.split("\r")
               |> List.first()
               |> Kernel.<>("\r")
               |> new!()
               |> inspect()
    end
  end

  describe "HL7.new/2" do
    test "can create new HL7 struct with ok tuple response" do
      result = new(@wiki_text)
      assert {:ok, new!(@wiki_text)} == result
    end

    test "can fail to create HL7 struct with error tuple response" do
      result = new("garbage")
      assert {:error, %HL7.InvalidMessage{}} = result
    end
  end

  describe "HL7.new!/2" do
    test "can create HL7 struct (with a list of segment maps) from HL7 text" do
      result = new!(@wiki_text)
      assert is_list(result.segments)
      assert Enum.all?(result.segments, &is_map/1)
      assert match?(%HL7{}, result)
    end

    test "can create HL7 struct from HL7 segment list" do
      segments = @wiki_text |> new!() |> get_segments()
      assert new!(@wiki_text) == new!(segments)
    end

    test "can create HL7 struct from HL7.Message struct" do
      msg = @wiki_text |> HL7.Message.new()
      assert new!(@wiki_text) == new!(msg)
    end

    test "can convert HL7 Maps back and forth to text" do
      converted = @wiki_text |> new!() |> to_string()
      assert converted == @wiki_text
    end
  end

  describe "HL7.label/2" do
    test "can label source data using an output map template" do
      result = @wiki_text |> new!() |> label(%{mrn: ~p"PID-3!", name: ~p"PID-5.2"})
      assert %{mrn: "56782445", name: "BARRY"} == result
    end

    test "can label source data using an output map template with functions" do
      fun = fn data -> get(data, ~p"PID-5.2") end
      result = @wiki_text |> new!() |> label(%{mrn: ~p"PID-3!", name: fun})
      assert %{mrn: "56782445", name: "BARRY"} == result
    end

    test "can label source data using an output map template with nested maps" do
      result =
        @wiki_text
        |> new!()
        |> label(%{address: %{main: ~p"PID-11!", alt: ~p"PID-11[2]!"}, name: ~p"PID-5.2"})

      assert %{
               name: "BARRY",
               address: %{alt: "NICKELL’S PICKLES", main: "260 GOODWIN CREST DRIVE"}
             } ==
               result
    end

    test "can label source data using an output map template with nested lists" do
      result =
        @wiki_text
        |> new!()
        |> label(%{address: [~p"PID-11!", ~p"PID-11[2]!"], name: ~p"PID-5.2"})

      assert %{address: ["260 GOODWIN CREST DRIVE", "NICKELL’S PICKLES"], name: "BARRY"} == result
    end

    test "can label source data with nils instead of empty strings" do
      result = @wiki_text |> new!() |> label(%{evn: ~p"EVN-2", no_evn: ~p"EVN-3"})
      assert %{evn: "200605290901", no_evn: nil} == result
    end

    test "can label source data with constant included" do
      result = @wiki_text |> new!() |> label(%{evn: ~p"EVN-2", hard: "coded"})
      assert %{evn: "200605290901", hard: "coded"} == result
    end
  end

  describe "HL7.chunk_by_lead_segment/2" do
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

  describe "HL7.to_list/1" do
    test "converts HL7 Structs to HL7 list data" do
      list = @wiki_text |> new!() |> to_list()
      assert is_list(list)
      assert Enum.all?(list, &is_list/1)

      assert [
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
             ] == Enum.at(list, 4)
    end
  end

  test "Can open a good mllp message from file stream using file type inference" do
    filepath = tmp_path("wiki.hl7")
    wiki_hl7 = HL7.Examples.wikipedia_sample_hl7()
    File.write!(filepath, @sb <> wiki_hl7 <> @ending)
    assert wiki_hl7 == open_hl7_file_stream(filepath) |> Enum.at(0)
  end

  test "Can open a good message from file stream using file type inference" do
    filepath = tmp_path("wiki.hl7")
    wiki_hl7 = HL7.Examples.wikipedia_sample_hl7()
    File.write!(filepath, wiki_hl7)
    assert wiki_hl7 == open_hl7_file_stream(filepath) |> Enum.at(0)
  end

  test "Attempting to open a bogus file returns unrecognized_file_type type error when using file type inference" do
    filepath = tmp_path("not_really_hl7.hl7")
    File.write!(filepath, "NOT A REAL HL7 FILE.")
    assert {:error, :unrecognized_file_type} == open_hl7_file_stream(filepath)
  end

  test "Attempting to open a non-existent file returns {:error, :enoent} when using file type inference" do
    filepath = tmp_path("no_such_file.hl7")
    assert {:error, :enoent} == open_hl7_file_stream(filepath)
  end

  test "Attempting to open a non-existent file returns {:error, :enoent} for :mllp" do
    filepath = tmp_path("no_such_file.hl7")
    assert {:error, :enoent} == open_hl7_file_stream(filepath, :mllp)
  end

  test "Can open a good message from file stream using split stream" do
    filepath = tmp_path("wiki.hl7")
    wiki_hl7 = HL7.Examples.wikipedia_sample_hl7()
    File.write!(filepath, wiki_hl7)
    assert wiki_hl7 == open_hl7_file_stream(filepath) |> Enum.at(0)
  end
end
