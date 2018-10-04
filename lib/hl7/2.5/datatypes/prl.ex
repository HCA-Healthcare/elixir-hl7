defmodule HL7.V2_5.DataTypes.Prl do
  @moduledoc """
  The "PRL" (PRL) data type
  """
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      parent_observation_identifier: DataTypes.Ce,
      parent_observation_subidentifier: nil,
      parent_observation_value_descriptor: nil
    ]
end
