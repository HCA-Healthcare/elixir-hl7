defmodule HL7.InspectTest do
  use ExUnit.Case
  import HL7

  test "Can inspect an HL7 message struct (long version)" do
    assert "#HL7[with 8 segments]" ==
             HL7.Examples.wikipedia_sample_hl7() |> new!() |> inspect()
  end

  test "Can inspect an HL7 message struct (short version)" do
    assert "#HL7[with 1 segment]" ==
             HL7.Examples.wikipedia_sample_hl7()
             |> String.split("\r")
             |> List.first()
             |> Kernel.<>("\r")
             |> new!()
             |> inspect()
  end
end
