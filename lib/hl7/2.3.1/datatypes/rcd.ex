defmodule Hl7.V2_3_1.DataTypes.Rcd do
  @moduledoc """
  The "RCD" (RCD) data type
  """

  use Hl7.DataType,
    fields: [
      segment_field_name: nil,
      hl7_date_type: nil,
      maximum_column_width: nil
    ]
end
