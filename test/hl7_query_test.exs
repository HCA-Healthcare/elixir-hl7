defmodule HL7QueryTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Query
  doctest HL7.Message
  import HL7.Query

  @wiki HL7.Examples.wikipedia_sample_hl7() |> HL7.Message.new()
  @nist HL7.Examples.nist_immunization_hl7() |> HL7.Message.new()
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

  test "Default query is struct with correct defaults" do
    query = %HL7.Query{}
    assert query.selections == []
    assert query.invalid_message == nil
    assert query.part == nil
  end

  test "Default selection in query is struct with correct defaults" do
    selection = %HL7.Selection{}
    assert selection.segments == []
  end

  test "Default separators equals struct from new" do
    separators = %HL7.Separators{}
    %HL7.Separators{field: field, encoding_characters: encoding_characters} = separators
    assert separators == HL7.Separators.new(field, encoding_characters)
  end

  test "Modified separators equals struct from new" do
    separators = %HL7.Separators{field: "#"}
    %HL7.Separators{field: field, encoding_characters: encoding_characters} = separators
    assert separators == HL7.Separators.new(field, encoding_characters)
  end

  test "Select of query returns itself" do
    query = select(@wiki)
    assert select(query) == query
  end

  test "Select invalid message returns query with embedded invalid message" do
    invalid_msg = HL7.Message.new("invalid content")
    query = select(invalid_msg)
    assert query.invalid_message == invalid_msg
  end

  test "Query back to message" do
    m = select(@wiki) |> to_message() |> to_string
    assert m == wiki()
  end

  test "get all segment names" do
    names = select(@wiki) |> get_segment_names()
    assert names == ["MSH", "EVN", "PID", "PV1", "OBX", "OBX", "AL1", "DG1"]
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
    assert HL7.Segment.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select one segment group from segments as list data" do
    list_data = HL7.Message.new(@wiki) |> HL7.Message.to_list()
    groups = select(list_data, "OBX AL1 DG1") |> get_segment_groups()
    segments = groups |> List.first()
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 3
    assert HL7.Segment.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select one segment group from segments as HL7 Message struct" do
    msg = HL7.Message.new(@wiki)
    groups = select(msg, "OBX AL1 DG1") |> get_segment_groups()
    segments = groups |> List.first()
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 3
    assert HL7.Segment.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select segment groups with optional segments" do
    groups = select(@wiki, "OBX [AL1] [DG1]") |> get_segment_groups()
    count = select(@wiki, "OBX [AL1] [DG1]") |> get_selection_count()
    segments = groups |> Enum.at(1)
    segment = segments |> Enum.at(1)

    assert count == 2
    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 3
    assert HL7.Segment.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select NO segments via groups with mismatch" do
    segments = select(@wiki, "OBX DG1") |> get_segment_groups()
    count = select(@wiki, "OBX DG1") |> get_selection_count()
    assert segments == []
    assert count == 0
  end

  test "extract a segment field from the first segment" do
    part = select(@wiki) |> get_part("3")
    assert part == "MegaReg"
  end

  test "extract a segment field from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2")
    assert part == ["N", ["K", "M"]]
  end

  test "extract part of a segment repetition from the first named segment" do
    part = select(@wiki) |> get_part("PID-11[2].3")
    assert part == "BIRMINGHAM"
  end

  test "extract a segment component from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2.1")
    assert part == "N"
  end

  test "extract a segment subcomponent from the first named segment" do
    part = select(@wiki) |> get_part("OBX-2.2.2")
    assert part == "M"
  end

  test "extract multiple segment parts at once" do
    part = select(@wiki) |> get_parts("OBX-6.2")
    assert part == ["Meter", "Kilogram"]
  end

  test "extract a segment value from the first sub-selected segment" do
    part = select(@wiki) |> select("PID") |> get_part("11[1].5")
    assert part == "35209"
  end

  test "extract multiple segment values from the sub-selected segments" do
    parts = select(@wiki) |> select("OBX") |> get_parts("1")
    assert parts == ["1", "2"]
  end

  test "filter segment type by name" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]") |> filter_segments("OBX") |> get_segment_names()

    assert segment_names == ["OBX", "OBX"]
  end

  test "filter a list of segment types" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]") |> filter_segments(["OBX", "DG1"]) |> get_segment_names()

    assert segment_names == ["OBX", "OBX", "DG1"]
  end

  test "filter with a query function" do
    filter_func = fn q ->
      p = q |> get_part("6.3")
      p == "ISO+"
    end

    segment_names = select(@wiki) |> filter_segments(filter_func) |> get_segment_names()
    assert segment_names == ["OBX", "OBX"]
  end

  test "filter with a query function from raw text" do
    filter_func = fn q ->
      p = q |> get_part("6.3")
      p == "ISO+"
    end

    segment_names = @wiki |> filter_segments(filter_func) |> get_segment_names()
    assert segment_names == ["OBX", "OBX"]
  end

  test "filter segments from raw text" do
    segment_names = @nist |> filter_segments("PID") |> get_segment_names()
    assert segment_names == ["PID"]
  end

  test "filter segments through a sub-select" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("OBX")
      |> filter_segments("OBX")
      |> get_segment_names()

    assert segment_names == [
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX",
             "OBX"
           ]
  end

  test "filter segments through multiple sub-selects" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("ORC RXA")
      |> select("RXA")
      |> filter_segments("RXA")
      |> get_segment_names()

    assert segment_names == ["RXA", "RXA"]
  end

  test "filter segments through invalid selections of a sub-select with a function" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("ZZZ")
      |> filter_segments(fn q ->
        rem(get_index(q), 2) == 0
      end)
      |> get_segment_names()

    assert segment_names == []
  end

  test "reject segments by name" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]") |> reject_segments("OBX") |> get_segment_names()

    assert segment_names == ["AL1", "DG1"]
  end

  test "reject segments by name from raw text" do
    segment_names = @wiki |> reject_segments("OBX") |> get_segment_names()

    assert segment_names == ["MSH", "EVN", "PID", "PV1", "AL1", "DG1"]
  end

  test "reject segments by name from list data" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]")
      |> get_segments()
      |> reject_segments("OBX")
      |> get_segment_names()

    assert segment_names == ["AL1", "DG1"]
  end

  test "reject segments a list of segment types" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]") |> reject_segments(["OBX", "DG1"]) |> get_segment_names()

    assert segment_names == ["AL1"]
  end

  test "reject segments a list of segment types from raw text" do
    segment_names = @wiki |> reject_segments(["OBX", "DG1"]) |> get_segment_names()

    assert segment_names == ["MSH", "EVN", "PID", "PV1", "AL1"]
  end

  test "reject segments a list of segment types from list data" do
    segment_names =
      select(@wiki, "OBX [AL1] [DG1]")
      |> get_segments()
      |> reject_segments(["OBX", "DG1"])
      |> get_segment_names()

    assert segment_names == ["AL1"]
  end

  test "reject with a query function" do
    filter_func = fn q ->
      p = q |> get_part("1")
      p != "1"
    end

    segment_names = select(@wiki) |> reject_segments(filter_func) |> get_segment_names()
    assert segment_names == ["OBX", "AL1", "DG1"]
  end

  test "reject with a query function from raw text" do
    filter_func = fn q ->
      p = q |> get_part("1")
      p != "1"
    end

    segment_names = @wiki |> reject_segments(filter_func) |> get_segment_names()
    assert segment_names == ["OBX", "AL1", "DG1"]
  end

  test "reject segments through invalid selections of a sub-select with a function" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("ZZZ")
      |> reject_segments(fn q ->
        rem(get_index(q), 2) == 0
      end)
      |> get_segment_names()

    assert segment_names == []
  end

  test "append a segment" do
    segment = ["ZZZ", "1", "sleep"]
    segment_names = select(@wiki, "OBX [AL1] [DG1]") |> append(segment) |> get_segment_names()
    assert segment_names == ["OBX", "ZZZ", "OBX", "AL1", "DG1", "ZZZ"]
  end

  test "append multiple segments" do
    segments = [["ZZ1", "1", "sleep"], ["ZZ2", "2", "more sleep"]]
    segment_names = select(@wiki, "OBX [AL1] [DG1]") |> append(segments) |> get_segment_names()
    assert segment_names == ["OBX", "ZZ1", "ZZ2", "OBX", "AL1", "DG1", "ZZ1", "ZZ2"]
  end

  test "prepend a segment" do
    segment = ["ZZZ", "1", "sleep"]
    segment_names = select(@wiki, "OBX [AL1] [DG1]") |> prepend(segment) |> get_segment_names()
    assert segment_names == ["ZZZ", "OBX", "ZZZ", "OBX", "AL1", "DG1"]
  end

  test "prepend multiple segments" do
    segments = [["ZZ1", "1", "sleep"], ["ZZ2", "2", "more sleep"]]
    segment_names = select(@wiki, "OBX [AL1] [DG1]") |> prepend(segments) |> get_segment_names()
    assert segment_names == ["ZZ1", "ZZ2", "OBX", "ZZ1", "ZZ2", "OBX", "AL1", "DG1"]
  end

  test "inject and retrieve replacements that build empty array data between elements while preserving content" do
    query = select(@wiki) |> replace_parts("PID-5.2.3", fn q -> q.part <> " PHD" end)
    assert query |> get_part("PID-5.2.3") == "BARRY PHD"
    assert query |> get_part("PID-5.1") == "KLEINSAMPLE"
  end

  test "inject list content with a replace_parts" do
    query = select(@wiki) |> replace_parts("PID-5.2", fn q -> [q.part, "PHD"] end)
    assert query |> get_part("PID-5.2") == ["BARRY", "PHD"]
    assert query |> get_part("PID-5.1") == "KLEINSAMPLE"
  end

  test "inject and retrieve replacements beyond the original segment field count" do
    query = select(@wiki) |> replace_parts("AL1-5[2].3.4", "MODIFIED")
    assert query |> get_part("AL1-5[2].3.4") == "MODIFIED"
    assert query |> get_part("AL1-5[2].3.3") == ""
    assert query |> get_part("AL1-5[2].2") == ""
    assert query |> get_part("AL1-5[1]") == ""
  end

  test "reject z segments" do
    segments = [["ZZZ", "1", "sleep"], ["ZZZ", "2", "sleep more"]]

    segment_names =
      select(@wiki, "OBX [AL1] [DG1]")
      |> append(segments)
      |> reject_z_segments()
      |> get_segment_names()

    assert segment_names == ["OBX", "OBX", "AL1", "DG1"]
  end

  test "delete selections with a function" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("OBX")
      |> delete(fn q ->
        rem(get_index(q), 2) == 0
      end)
      |> get_segment_names()

    assert segment_names == ["OBX", "OBX", "OBX", "OBX", "OBX", "OBX", "OBX"]
  end

  test "replace selections with a function" do
    segment_names =
      select(@nist, "ORC {RXA} {RXR} [{OBX}]")
      |> select("OBX")
      |> replace(fn q -> [["ZZZ", get_index(q), "sleep"]] end)
      |> get_segment_names()

    assert segment_names == [
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ",
             "ZZZ"
           ]
  end

  test "map a list of segment types" do
    assert true
  end
end
