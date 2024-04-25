defmodule HL7.ToListTest do
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

  test "converts HL7 Structs to HL7 list data" do
    list = wiki_text() |> new!() |> to_list()
    assert is_list(list)
    assert Enum.all?(list, &is_list/1)
  end

  test "converts HL7 Segments to HL7 list data" do
    segment = wiki_text() |> new!() |> get_segments() |> Enum.at(4) |> to_list()

    assert [
             "OBX",
             "1",
             [["N", ["K", "M"]]],
             [["", "Body Height"]],
             "",
             "1.80",
             [["m", "Meter", "ISO+"]],
             "",
             "",
             "",
             "",
             "F"
           ] == segment
  end
end
