defmodule HL7.V2_3_1.DataTypes.Spd do
  @moduledoc false

  use HL7.DataType,
    fields: [
      specialty_name: nil,
      governing_board: nil,
      eligible_or_certified: nil,
      date_of_certification: nil
    ]
end
