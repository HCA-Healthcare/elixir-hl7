defmodule HL7.V2_2.DataTypes.Cmrfr do
  @moduledoc false
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
			reference_range: DataTypes.Ce,
			sex: nil,
			age_range: DataTypes.Ce,
			gestational_age_range: DataTypes.Ce,
			species: nil,
			race_subspecies: nil,
			text_condition: nil
    ]
end
