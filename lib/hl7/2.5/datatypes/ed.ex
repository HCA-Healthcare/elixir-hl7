defmodule HL7.V2_5.DataTypes.Ed do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
			source_application: DataTypes.Hd,
			type_of_data: nil,
			data_subtype: nil,
			encoding: nil,
			data: nil
    ]
end
