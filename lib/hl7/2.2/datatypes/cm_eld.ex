defmodule Hl7.V2_2.DataTypes.Cmeld do
  @moduledoc """
  The "CM_ELD" (CM_ELD) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      segmentid: nil,
      sequence: nil,
      fieldposition: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
