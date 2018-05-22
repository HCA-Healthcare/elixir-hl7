defmodule Hl7.V2_3.DataTypes.Cmeld do
  @moduledoc """
  The "CM_ELD" (CM_ELD) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      segment_id: nil,
      sequence: nil,
      field_position: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
