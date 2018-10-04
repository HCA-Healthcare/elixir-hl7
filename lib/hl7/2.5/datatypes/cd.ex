defmodule HL7.V2_5.DataTypes.Cd do
  @moduledoc """
  The "CD" (CD) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      channel_identifier: DataTypes.Wvi,
      waveform_source: DataTypes.Wvs,
      channel_sensitivityunits: DataTypes.Csu,
      channel_calibration_parameters: DataTypes.Ccp,
      channel_sampling_frequency: nil,
      minimummaximum_data_values: DataTypes.Nr
    ]
end
