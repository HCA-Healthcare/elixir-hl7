defmodule Hl7.V2_3_1.DataTypes.Jcc do
  @moduledoc """
  The "JCC" (JCC) data type
  """

  use Hl7.DataType,
    fields: [
      job_code: nil,
      job_class: nil
    ]
end
