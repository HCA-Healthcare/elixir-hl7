defmodule HL7.V2_5_1.DataTypes.Jcc do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			job_code: nil,
			job_class: nil,
			job_description_text: nil
    ]
end
