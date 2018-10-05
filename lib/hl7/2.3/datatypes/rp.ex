defmodule HL7.V2_3.DataTypes.Rp do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
			pointer: nil,
			application_id: DataTypes.Hd,
			type_of_data: nil,
			subtype: nil
    ]
end
