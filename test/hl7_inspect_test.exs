defmodule HL7.InspectTest do
  use ExUnit.Case
  import HL7

  test "Can inspect an HL7 message struct (long version)" do
    assert "#HL7[MSH, EVN, PID, PV1, OBX, +3]" ==
             HL7.Examples.wikipedia_sample_hl7() |> new!() |> inspect()
  end

  test "Can inspect an HL7 message struct (short version)" do
    assert "#HL7[MSH, EVN, PID]" ==
             HL7.Examples.wikipedia_sample_hl7()
             |> String.split("\r")
             |> Enum.take(3)
             |> Enum.join("\r")
             |> new!()
             |> inspect()
  end
end
