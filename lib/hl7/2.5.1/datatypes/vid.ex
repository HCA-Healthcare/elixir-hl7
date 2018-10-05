defmodule HL7.V2_5_1.DataTypes.Vid do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			version_id: nil,
			internationalization_code: DataTypes.Ce,
			international_version_id: DataTypes.Ce
    ]
end
