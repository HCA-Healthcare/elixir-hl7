defmodule HL7.V2_5.DataTypes.Jcc do
  @moduledoc """
  The "JCC" (JCC) data type
  """

  use HL7.DataType,
    fields: [
      job_code: nil,
      job_class: nil,
      job_description_text: nil
    ]
end
