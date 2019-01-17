defmodule HL7QueryTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Query
  import HL7.Query

  @wiki HL7.Examples.wikipedia_sample_hl7()

  test "query back to message" do
    m = new(@wiki) |> to_message() |> to_string
    assert m == @wiki
  end

  test "select one simple segment" do
    groups = select(@wiki, "MSH") |> to_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 4) == "XYZHospC"
  end

  test "select multiple simple segments" do
    groups = select(@wiki, "OBX") |> to_groups()
    segments = groups |> List.first()
    segment = segments |> List.first()

    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 1
    assert Enum.at(segment, 5) == "1.80"
  end

  test "select one segment group" do
    groups = select(@wiki, "OBX AL1 DG1") |> to_groups()
    segments = groups |> List.first()
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 1
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select segment groups with optional segments" do
    groups = select(@wiki, "OBX {AL1} {DG1}") |> to_groups()
    segments = groups |> Enum.at(1)
    segment = segments |> Enum.at(1)

    assert Enum.count(groups) == 2
    assert Enum.count(segments) == 3
    assert HL7.Message.get_part(segment, 3, 0, 1) == "ASPIRIN"
  end

  test "select NO segments via groups with mismatch" do
    groups = select(@wiki, "OBX DG1") |> to_groups()
    segments = groups |> List.first()
    assert groups == []
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
