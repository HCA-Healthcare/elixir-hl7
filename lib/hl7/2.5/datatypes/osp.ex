defmodule Hl7.V2_5.DataTypes.Osp do
  @moduledoc """
  The "OSP" (OSP) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      occurrence_span_code: DataTypes.Cne,
      occurrence_span_start_date: nil,
      occurrence_span_stop_date: nil
    ]
end
