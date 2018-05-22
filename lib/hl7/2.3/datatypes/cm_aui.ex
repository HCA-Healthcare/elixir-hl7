defmodule Hl7.V2_3.DataTypes.Cmaui do
  @moduledoc """
  The "CM_AUI" (CM_AUI) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      authorization_number: nil,
      date: DataTypes.Ts,
      source: nil
    ]
end
