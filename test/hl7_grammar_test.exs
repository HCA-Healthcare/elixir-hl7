defmodule HL7GrammarTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Grammar
  import HL7.Grammar

  test "single segment grammar" do
    g = new("OBX")
    assert g.children == ["OBX"]
    assert g.optional == false
    assert g.repeating == false
  end

  test "multi segment grammar" do
    g = new("OBX AL1")
    assert g.children == ["OBX", "AL1"]
    assert g.optional == false
    assert g.repeating == false
  end

  test "fully optional grammar is invalid" do
    g = new("{OBX} {AL1 [{PV1 OBR}] NTE}")
    assert %HL7.InvalidGrammar{} = g
    assert :no_required_segments = g.reason
  end

  test "bad tokens are invalid" do
    g = new("{OBX} - {AL1 [{PV1 OBR}] NTE}")
    assert %HL7.InvalidGrammar{} = g
    assert :invalid_token = g.reason
  end

  test "optional child grammar" do
    g = new("OBX {AL1}")

    assert %HL7.Grammar{} = g
    assert ["OBX" | _] = g.children

    ["OBX", inner_child | _] = g.children

    assert %HL7.Grammar{} = inner_child
    assert ["AL1"] = inner_child.children
    assert true == inner_child.optional

    assert %HL7.Grammar{
             children: [
               "OBX",
               %HL7.Grammar{
                 children: ["AL1"],
                 optional: true,
                 repeating: false
               }
             ],
             optional: false,
             repeating: false
           } == g
  end

  test "repeating child grammar" do
    g = new("OBX [AL1]")

    assert %HL7.Grammar{} = g
    assert ["OBX" | _] = g.children

    ["OBX", inner_child | _] = g.children

    assert %HL7.Grammar{} = inner_child
    assert ["AL1"] = inner_child.children
    assert true == inner_child.repeating

    assert %HL7.Grammar{
             children: [
               "OBX",
               %HL7.Grammar{
                 children: ["AL1"],
                 optional: false,
                 repeating: true
               }
             ],
             optional: false,
             repeating: false
           } == g
  end

  test "repeating and optional child grammar" do
    g = new("OBX [{AL1}]")

    assert %HL7.Grammar{} = g
    assert ["OBX" | _] = g.children

    ["OBX", inner_child | _] = g.children

    assert %HL7.Grammar{} = inner_child
    assert [%HL7.Grammar{}] = inner_child.children
    assert true == inner_child.repeating

    assert %HL7.Grammar{
             children: [
               "OBX",
               %HL7.Grammar{
                 children: [
                   %HL7.Grammar{
                     children: ["AL1"],
                     optional: true,
                     repeating: false
                   }
                 ],
                 optional: false,
                 repeating: true
               }
             ],
             optional: false,
             repeating: false
           } == g
  end

  test "nested grammar" do
    g = new("OBX [NTE [{AL1}]]")

    assert %HL7.Grammar{
             children: [
               "OBX",
               %HL7.Grammar{
                 children: [
                   "NTE",
                   %HL7.Grammar{
                     children: [
                       %HL7.Grammar{children: ["AL1"], optional: true, repeating: false}
                     ],
                     optional: false,
                     repeating: true
                   }
                 ],
                 optional: false,
                 repeating: true
               }
             ],
             optional: false,
             repeating: false
           } == g
  end
end
