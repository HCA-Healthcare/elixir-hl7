defmodule HL7.PutTest do
  use ExUnit.Case
  require Logger
  doctest HL7

  import HL7
  #  import HL7, only: :sigils

  # placed here for viewing convenience
  def wiki_text() do
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

  test "can put field data as string" do
    msg = wiki_text() |> new!() |> put(~p"PID-8", "F")
    assert "F" == get(msg, ~p"PID-8")
  end

  test "can put field data as string overwriting map" do
    msg = wiki_text() |> new!() |> put(~p"PID-3", "SOME_ID")
    assert "SOME_ID" == get(msg, ~p"PID-3")
  end

  test "can put field data as string overwriting map of repetitions" do
    msg = wiki_text() |> new!() |> put(~p"PID-11[*]", "SOME_ID")
    assert ["SOME_ID"] == get(msg, ~p"PID-11[*]")
  end

  test "can put field data as repetition map overwriting repetitions" do
    msg =
      wiki_text()
      |> new!()
      |> put(~p"PID-11[*]", %{1 => "SOME_ID", 2 => "OTHER_ID", 3 => "FINAL_ID"})

    assert ["SOME_ID", "OTHER_ID", "FINAL_ID"] == get(msg, ~p"PID-11[*]")
  end

  test "can put field data as map overwriting map" do
    map = %{1 => "123", 4 => "XX", 5 => "BB"}
    msg = wiki_text() |> new!() |> put(~p"PID-3", map)
    assert map == get(msg, ~p"PID-3")
  end

  test "can put repetition data as map overwriting map" do
    map = %{1 => "123", 4 => "XX", 5 => "BB"}
    msg = wiki_text() |> new!() |> put(~p"PID-3[1]", map)
    assert map == get(msg, ~p"PID-3[1]")
  end

  test "can put repetition data as map extending map" do
    map = %{1 => "123", 4 => "XX", 5 => "BB"}
    msg = wiki_text() |> new!() |> put(~p"PID-3[2]", map)
    assert map == get(msg, ~p"PID-3[2]")
  end

  test "can put repetition data across multiple components" do
    msg = wiki_text() |> new!() |> put(~p"PID-11[*].3", "SOME_PLACE")
    assert ["SOME_PLACE", "SOME_PLACE"] == get(msg, ~p"PID-11[*].3")
  end

  test "can put repetition data across multiple subcomponents" do
    msg = wiki_text() |> new!() |> put(~p"PID-11[*].3.2", "SOME_PLACE")
    assert ["SOME_PLACE", "SOME_PLACE"] == get(msg, ~p"PID-11[*].3.2")
  end

  test "can put repetition data across multiple components with partial path" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"11[*].3", "SOME_PLACE")
    assert ["SOME_PLACE", "SOME_PLACE"] == get(pid, ~p"11[*].3")
  end

  test "can put repetition data across multiple subcomponents with partial path" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"11[*].3.2", "SOME_PLACE")
    assert ["SOME_PLACE", "SOME_PLACE"] == get(pid, ~p"11[*].3.2")
  end

  test "can put data in a segment using partial path to field" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3")
  end

  test "can put data in a segment using partial path to repetition" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3[2]", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3[2]")
  end

  test "can put data in a segment using partial path to component" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3.2", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3.2")
  end

  test "can put data in a segment using partial path to subcomponent" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3.2.4", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3.2.4")
  end

  test "can put data in a segment using partial path to repetition and component" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3[2].2", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3[2].2")
  end

  test "can put data in a segment using partial path to repetition and subcomponent" do
    pid = wiki_text() |> new!() |> get(~p"PID") |> put(~p"3[1].2.4", "SOME_ID")
    assert "SOME_ID" == get(pid, ~p"3[1].2.4")
  end

  test "can put component data in a string field" do
    msg = wiki_text() |> new!() |> put(~p"PID-8.2", "EXTRA")
    assert "EXTRA" == get(msg, ~p"PID-8.2")
    assert "M" == get(msg, ~p"PID-8.1")
  end

  test "can put data across multiple segments" do
    msg = wiki_text() |> new!() |> put(~p"OBX[*]-5", "REDACTED")
    assert ["REDACTED", "REDACTED"] == get(msg, ~p"OBX[*]-5")
  end

  test "can put across a list of repetitions" do
    reps = wiki_text() |> new!() |> get(~p"PID-11[*]")
    assert ["REDACTED", "REDACTED"] == put(reps, ~p".2", "REDACTED") |> get(~p".2")
  end

  test "can put in a repetition" do
    rep = wiki_text() |> new!() |> get(~p"PID-11[2]")
    assert "REDACTED" == put(rep, ~p".2", "REDACTED") |> get(~p".2")
  end

  test "can raise if putting a larger path directly against a repetition" do
    rep = wiki_text() |> new!() |> get(~p"PID-11[2]")
    assert_raise RuntimeError, fn -> put(rep, ~p"2.2", "REDACTED") end
  end

end
