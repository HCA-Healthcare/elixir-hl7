defmodule HL7.ExamplesTest do
  use ExUnit.Case
  require Logger
  doctest HL7.Examples

  test "The nist_syndromic_hl7 example is a valid message" do
    msg =
      HL7.Examples.nist_syndromic_hl7()
      |> HL7.Message.new()

    assert %HL7.Message{} = msg
  end
end
