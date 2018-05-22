defmodule Hl7.V2_5_1.DataTypes.Ccp do
  @moduledoc """
  The "CCP" (CCP) data type
  """

  use Hl7.DataType,
    fields: [
      channel_calibration_sensitivity_correction_factor: nil,
      channel_calibration_baseline: nil,
      channel_calibration_time_skew: nil
    ]
end
