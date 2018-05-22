defmodule Hl7.V2_5.DataTypes.Ma do
  @moduledoc """
  The "MA" (MA) data type
  """

  use Hl7.DataType,
    fields: [
      sample_1_from_channel_1: nil,
      sample_1_from_channel_2: nil,
      sample_1_from_channel_n: nil,
      sample_2_from_channel_1: nil,
      sample_2_from_channel_n: nil,
      sample_n_from_channel_n: nil
    ]
end
