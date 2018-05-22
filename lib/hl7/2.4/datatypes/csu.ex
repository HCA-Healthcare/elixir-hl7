defmodule Hl7.V2_4.DataTypes.Csu do
  @moduledoc """
  The "CSU" (CSU) data type
  """

  use Hl7.DataType,
    fields: [
      channel_sensitivity: nil,
      unit_of_measure_identifier: nil,
      unit_of_measure_description: nil,
      unit_of_measure_coding_system: nil,
      alternate_unit_of_measure_identifier: nil,
      alternate_unit_of_measure_description: nil,
      alternate_unit_of_measure_coding_system: nil
    ]
end
