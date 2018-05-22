defmodule Hl7.V2_2.DataTypes.Cmrfr do
  @moduledoc """
  The "CM_RFR" (CM_RFR) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
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
