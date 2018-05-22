defmodule Hl7.V2_3_1.DataTypes.Eld do
  @moduledoc """
  The "ELD" (ELD) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      segment_id: nil,
      sequence: nil,
      field_position: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
