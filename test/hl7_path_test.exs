defmodule HL7.PathTest do
  use ExUnit.Case
  doctest HL7.Path
  import HL7, only: :sigils

  test "creates an Path sigil" do
    assert match?(%HL7.Path{}, ~p"OBX")
  end

  test "notes the segment name and default segment number" do
    result = ~p"OBX"
    assert 1 == result.segment_number
    assert nil == result.field
    refute result.truncate
    assert "OBX" == result.segment
  end

  test "notes the segment name and specific segment number" do
    result = ~p"OBX[3]"
    assert 3 == result.segment_number
    assert nil == result.field
    assert "OBX" == result.segment
  end

  test "notes the segment name with a wildcard to select all of them" do
    result = ~p"OBX[*]"
    assert "*" == result.segment_number
    assert nil == result.field
    assert "OBX" == result.segment
  end

  test "notes the selected field of the given segment with the default repetition" do
    result = ~p"OBX-5"
    assert 5 == result.field
    assert 1 == result.repetition
    assert 1 == result.segment_number
    assert "OBX" == result.segment
  end

  test "notes a specific repetition" do
    result = ~p"OBX-5[2]"
    assert 5 == result.field
    assert 2 == result.repetition
    assert 1 == result.segment_number
    assert "OBX" == result.segment
  end

  test "prevents a repetition without a field" do
    assert_raise ArgumentError, fn -> HL7.Path.new("[3]") end
  end

  test "notes a wildcard repetition" do
    result = ~p"OBX-5[*]"
    assert 5 == result.field
    assert "*" == result.repetition
    assert 1 == result.segment_number
    assert "OBX" == result.segment
  end

  test "notes a wildcard repetition with a wildcard segment selection" do
    result = ~p"OBX[*]-5[*]"
    assert 5 == result.field
    assert "*" == result.repetition
    assert "*" == result.segment_number
    assert "OBX" == result.segment
  end

  test "notes the selected field and component" do
    result = ~p"OBX-5.2"
    assert 5 == result.field
    assert 1 == result.repetition
    assert 2 == result.component
    assert 1 == result.segment_number
    assert "OBX" == result.segment
  end

  test "notes the selected field, component and subcomponent" do
    result = ~p"OBX-5.2.4"
    assert 5 == result.field
    assert 1 == result.repetition
    assert 2 == result.component
    assert 4 == result.subcomponent
    assert 1 == result.segment_number
    assert "OBX" == result.segment
  end

  test "notes truncation" do
    result = ~p"OBX[2]-5!"
    assert 5 == result.field
    assert 1 == result.repetition
    assert 2 == result.segment_number
    assert result.truncate
    assert "OBX" == result.segment
  end

  test "to_string for HL7.Path" do
    path = %HL7.Path{segment: "OBX", segment_number: 1, field: 5, repetition: 1, component: nil, subcomponent: nil, truncate: false}
    assert to_string(path) == "OBX-5"

    path = %HL7.Path{segment: "PID", segment_number: 1, field: 11, repetition: 2, component: 1, subcomponent: nil, truncate: false}
    assert to_string(path) == "PID-11[2].1"

    path = %HL7.Path{segment: "OBX", segment_number: 1, field: 2, repetition: 1, component: 1, subcomponent: 2, truncate: false}
    assert to_string(path) == "OBX-2.1.2"

    path = %HL7.Path{segment: "OBX", segment_number: 2, field: 2, repetition: 1, component: nil, subcomponent: nil, truncate: true}
    assert to_string(path) == "OBX[2]-2"-
  end
end
