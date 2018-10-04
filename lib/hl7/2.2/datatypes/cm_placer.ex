defmodule HL7.V2_2.DataTypes.Cmplacer do
  @moduledoc """
  The "CM_PLACER" (CM_PLACER) data type
  """

  use HL7.DataType,
    fields: [
      unique_placer_id: nil,
      placer_application: nil
    ]
end
