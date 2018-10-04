defmodule HL7.V2_2.DataTypes.Cmccd do
  @moduledoc """
  The "CM_CCD" (CM_CCD) data type
  """
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      when_to_charge: nil,
      datetime: DataTypes.Ts
    ]
end
