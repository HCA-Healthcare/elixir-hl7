defmodule HL7.V2_5_1.DataTypes.Ccd do
  @moduledoc """
  The "CCD" (CCD) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      invocation_event: nil,
      datetime: DataTypes.Ts
    ]
end
