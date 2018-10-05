defmodule HL7.V2_4.DataTypes.Jcc do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			job_code: nil,
			job_class: nil
    ]
end
