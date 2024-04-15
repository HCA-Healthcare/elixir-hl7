defmodule HL7.LabelTest do
  use ExUnit.Case

  import HL7

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

  test "can label source data using an output map template" do
    result = wiki_text() |> new!() |> label(%{mrn: ~p"PID-3!", name: ~p"PID-5.2"})
    assert %{mrn: "56782445", name: "BARRY"} == result
  end

  test "can label source data using an output map template with functions" do
    fun = fn data -> get(data, ~p"PID-5.2") end
    result = wiki_text() |> new!() |> label(%{mrn: ~p"PID-3!", name: fun})
    assert %{mrn: "56782445", name: "BARRY"} == result
  end

  test "can label source data using an output map template with nested maps" do
    result =
      wiki_text()
      |> new!()
      |> label(%{address: %{main: ~p"PID-11!", alt: ~p"PID-11[2]!"}, name: ~p"PID-5.2"})

    assert %{name: "BARRY", address: %{alt: "NICKELL’S PICKLES", main: "260 GOODWIN CREST DRIVE"}} ==
             result
  end

  test "can label source data using an output map template with nested lists" do
    result =
      wiki_text() |> new!() |> label(%{address: [~p"PID-11!", ~p"PID-11[2]!"], name: ~p"PID-5.2"})

    assert %{address: ["260 GOODWIN CREST DRIVE", "NICKELL’S PICKLES"], name: "BARRY"} == result
  end

  test "can label source data with nils instead of empty strings" do
    result = wiki_text() |> new!() |> label(%{evn: ~p"EVN-2", no_evn: ~p"EVN-3"})
    assert %{evn: "200605290901", no_evn: nil} == result
  end

  test "can label source data with constant included" do
    result = wiki_text() |> new!() |> label(%{evn: ~p"EVN-2", hard: "coded"})
    assert %{evn: "200605290901", hard: "coded"} == result
  end
end
