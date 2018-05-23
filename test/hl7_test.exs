defmodule Hl7Test do
  use ExUnit.Case
  doctest Hl7

  test "Wikipedia message roundtrip" do
    hl7 = Hl7.Examples.wikipedia_sample_hl7()

    roundtrip =
      hl7
      |> Hl7.Message.new()
      |> Hl7.Message.make_structs()
      |> to_string()

    assert roundtrip == hl7
  end
end
