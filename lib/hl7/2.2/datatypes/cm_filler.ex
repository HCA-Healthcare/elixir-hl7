defmodule HL7.V2_2.DataTypes.Cmfiller do
  @moduledoc """
  The "CM_FILLER" (CM_FILLER) data type
  """

  use HL7.DataType,
    fields: [
      unique_filler_id: nil,
      filler_application_id: nil
    ]
end
