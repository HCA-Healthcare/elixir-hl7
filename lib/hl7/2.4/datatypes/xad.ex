defmodule HL7.V2_4.DataTypes.Xad do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      street_address_sad: DataTypes.Sad,
      other_designation: nil,
      city: nil,
      state_or_province: nil,
      zip_or_postal_code: nil,
      country: nil,
      address_type: nil,
      other_geographic_designation: nil,
      countyparish_code: nil,
      census_tract: nil,
      address_representation_code: nil,
      address_validity_range: DataTypes.Dr
    ]
end
