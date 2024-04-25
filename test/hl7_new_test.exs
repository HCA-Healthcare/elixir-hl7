defmodule HL7.NewTest do
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

  test "creates HL7 struct (with a list of segment maps) from HL7 text" do
    result = new!(wiki_text())
    assert is_list(result.segments)
    assert Enum.all?(result.segments, &is_map/1)
    assert match?(%HL7{}, result)
  end

  test "new! HL7 struct (with a list of segment maps) from HL7 text" do
    result = new!(wiki_text() |> HL7.Message.new())
    assert new!(wiki_text()) == result
  end

  test "can create new HL7 struct with ok tuple response" do
    result = new(wiki_text())
    assert {:ok, new!(wiki_text())} == result
  end

  test "can fail to create HL7 struct with error tuple response" do
    result = new("garbage")
    assert {:error, %HL7.InvalidMessage{}} = result
  end

  test "can convert HL7 Maps back and forth to text" do
    converted = wiki_text() |> new!() |> to_string()
    assert converted == wiki_text()
  end
end
