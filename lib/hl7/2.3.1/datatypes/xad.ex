defmodule Hl7.V2_3_1.DataTypes.Xad do
  @moduledoc """
  The "XAD" (XAD) data type
  """

  use Hl7.DataType,
    fields: [
      street_address: nil,
      other_designation: nil,
      city: nil,
      state_or_province: nil,
      zip_or_postal_code: nil,
      country: nil,
      address_type: nil,
      other_geographic_designation: nil,
      countyparish_code: nil,
      census_tract: nil,
      address_representation_code: nil
    ]
end
