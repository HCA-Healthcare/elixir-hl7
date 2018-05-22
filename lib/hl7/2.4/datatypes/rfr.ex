defmodule Hl7.V2_4.DataTypes.Rfr do
  @moduledoc """
  The "RFR" (RFR) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      numeric_range: DataTypes.Nr,
      administrative_sex: nil,
      age_range: DataTypes.Nr,
      gestational_range: DataTypes.Nr,
      species: nil,
      racesubspecies: nil,
      conditions: nil
    ]
end
