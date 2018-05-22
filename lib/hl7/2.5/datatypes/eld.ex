defmodule Hl7.V2_5.DataTypes.Eld do
  @moduledoc """
  The "ELD" (ELD) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      segment_id: nil,
      segment_sequence: nil,
      field_position: nil,
      code_identifying_error: DataTypes.Ce
    ]
end
