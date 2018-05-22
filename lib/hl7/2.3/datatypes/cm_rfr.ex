defmodule Hl7.V2_3.DataTypes.Cmrfr do
  @moduledoc """
  The "CM_RFR" (CM_RFR) data type
  """

  use Hl7.DataType,
    fields: [
      reference_range: nil,
      sex: nil,
      age_range: nil,
      age_gestation: nil,
      species: nil,
      racesubspecies: nil,
      conditions: nil
    ]
end
