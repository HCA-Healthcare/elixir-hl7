defmodule HL7.V2_5_1.DataTypes.Rp do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			pointer: nil,
			application_id: DataTypes.Hd,
			type_of_data: nil,
			subtype: nil
    ]
end
