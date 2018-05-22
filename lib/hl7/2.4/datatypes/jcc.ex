defmodule Hl7.V2_4.DataTypes.Jcc do
  @moduledoc """
  The "JCC" (JCC) data type
  """

  use Hl7.DataType,
    fields: [
      job_code: nil,
      job_class: nil
    ]
end
