defmodule HL7.V2_3_1.DataTypes.Cd do
  @moduledoc """
  The "CD" (CD) data type
  """
  alias HL7.V2_3_1.{DataTypes}

  use HL7.DataType,
    fields: [
      channel_identifier: DataTypes.Wvi,
      electrode_names: DataTypes.Wvs,
      channel_sensitivityunits: DataTypes.Csu,
      calibration_parameters: DataTypes.Ccp,
      sampling_frequency: nil,
      minimummaximum_data_values: DataTypes.Nr
    ]
end
