defmodule HL7.V2_2.DataTypes.Cmosp do
  @moduledoc """
  The "CM_OSP" (CM_OSP) data type
  """

  use HL7.DataType,
    fields: [
      occurrence_span_code: nil,
      occurrence_span_start_date: nil,
      occurrence_span_stop_date: nil
    ]
end
