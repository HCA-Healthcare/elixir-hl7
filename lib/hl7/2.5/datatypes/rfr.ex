defmodule Hl7.V2_5.DataTypes.Rfr do
  @moduledoc """
  The "RFR" (RFR) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      numeric_range: DataTypes.Nr,
      administrative_sex: nil,
      age_range: DataTypes.Nr,
      gestational_age_range: DataTypes.Nr,
      species: nil,
      racesubspecies: nil,
      conditions: nil
    ]
end
