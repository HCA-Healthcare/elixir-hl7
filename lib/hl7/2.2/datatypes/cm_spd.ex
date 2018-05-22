defmodule Hl7.V2_2.DataTypes.Cmspd do
  @moduledoc """
  The "CM_SPD" (CM_SPD) data type
  """

  use Hl7.DataType,
    fields: [
      specialty_name: nil,
      governing_board: nil,
      eligible_or_certified: nil,
      date_of_certification: nil
    ]
end
