defmodule Hl7.V2_5_1.DataTypes.Prl do
  @moduledoc """
  The "PRL" (PRL) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      parent_observation_identifier: DataTypes.Ce,
      parent_observation_subidentifier: nil,
      parent_observation_value_descriptor: nil
    ]
end
