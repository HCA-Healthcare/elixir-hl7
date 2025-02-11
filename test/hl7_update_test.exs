defmodule HL7.UpdateTest do
  use ExUnit.Case

  import HL7

  def wiki_text(), do: HL7.Examples.wikipedia_sample_hl7()

  test "can update field data as string" do
    msg = wiki_text() |> new!() |> update(~p"PID-8", "F", fn data -> data <> "F" end)
    assert "MF" == get(msg, ~p"PID-8")
  end

  test "can update missing field data as string via default" do
    msg = wiki_text() |> new!() |> update(~p"PID-21", "X", fn data -> data <> "F" end)
    assert "X" == get(msg, ~p"PID-21")
  end

  test "can update field data as string overwriting map" do
    msg = wiki_text() |> new!() |> update(~p"PID-3", "SOME_ID", fn data -> data[1] <> "-X" end)
    assert "56782445-X" == get(msg, ~p"PID-3")
  end

  test "can update field data within a map" do
    msg = wiki_text() |> new!() |> update(~p"PID-3", nil, fn data -> Map.put(data, 1, "123") end)

    assert %{1 => "123", 4 => "UAReg", 5 => "PI"} == get(msg, ~p"PID-3")
  end

  test "can update repetition data within map" do
    msg = wiki_text() |> new!() |> update(~p"PID-3[1]", nil, &put(&1, ~p".2", "345"))
    assert "345" == get(msg, ~p"PID-3[1].2")
  end

  test "can update repetition data across multiple components" do
    msg = wiki_text() |> new!() |> update(~p"PID-11[*].3", nil, fn c -> c <> "2" end)
    assert ["BIRMINGHAM2", "BIRMINGHAM2"] == get(msg, ~p"PID-11[*].3")
  end

  test "can update repetition data across multiple components with partial path" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> update(~p"11[*].3", nil, fn c -> c <> "3" end)
    assert ["BIRMINGHAM3", "BIRMINGHAM3"] == get(pid, ~p"11[*].3")
  end

  test "can update data in a segment using partial path to field" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> update(~p"3", nil, fn f -> f[5] <> "4" end)
    assert "PI4" == get(pid, ~p"3")
  end

  test "can update data in a segment using partial path to repetition" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> update(~p"11[2]", nil, fn f -> f[3] <> "4" end)
    assert "BIRMINGHAM4" == get(pid, ~p"11[2]")
  end

  test "can update data in a segment using partial path to component" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> update(~p"11.4", nil, fn c -> c <> "5" end)
    assert "AL5" == get(pid, ~p"11.4")
  end

  test "can update data in a segment using partial path to subcomponent" do
    obx = wiki_text() |> new!() |> get(~p"OBX") |> update(~p"2.2.2", nil, fn s -> s <> "6" end)
    assert "M6" == get(obx, ~p"2.2.2")
  end

  test "can update data in a segment using partial path to repetition and component" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> update(~p"11[2].3", nil, fn c -> c <> "6" end)
    assert "BIRMINGHAM6" == get(pid, ~p"11[2].3")
  end

  test "can update data in a segment using partial path to repetition and subcomponent" do
    obx = wiki_text() |> new!() |> get(~p"OBX") |> update(~p"2[1].2.2", nil, fn s -> s <> "7" end)
    assert "M7" == get(obx, ~p"2[1].2.2")
  end

  test "can update component data in a string field" do
    msg = wiki_text() |> new!() |> update(~p"OBX-2.1", nil, fn c -> c <> "8" end)
    assert "N8" == get(msg, ~p"OBX-2.1")
  end

  test "can update data across multiple segments" do
    msg = wiki_text() |> new!() |> update(~p"OBX[*]-5", nil, fn f -> f <> " REDACTED" end)
    assert ["1.80 REDACTED", "79 REDACTED"] == get(msg, ~p"OBX[*]-5")
  end

  test "can update full segments across multiple segments" do
    msg = wiki_text() |> new!() |> update(~p"OBX[*]", nil fn s -> HL7.put(s, ~p"4", HL7.get(s, ~p"5") <> " JUNK") end)
    assert ["1.80 JUNK", "79 JUNK"] == get(msg, ~p"OBX[*]-4")
  end

  test "can update missing data across multiple segments with default values" do
    msg = wiki_text() |> new!() |> update(~p"OBX[*]-15", "JUNK", fn f -> f <> " REDACTED" end)
    assert ["JUNK", "JUNK"] == get(msg, ~p"OBX[*]-15")
  end

  test "can update! data without default values" do
    msg = wiki_text() |> new!() |> update!(~p"PID-11[*].3", fn c -> c <> "2" end)
    assert ["BIRMINGHAM2", "BIRMINGHAM2"] == get(msg, ~p"PID-11[*].3")
  end

  test "can fail to update! data with missing values" do
    msg = wiki_text() |> new!()
    assert_raise KeyError, fn -> update!(msg, ~p"PID-11[*].2", fn c -> c <> "2" end) end
  end
end
