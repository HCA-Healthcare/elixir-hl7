defmodule Hl7.V2_2.DataTypes.Cmccd do
  @moduledoc """
  The "CM_CCD" (CM_CCD) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      when_to_charge: nil,
      datetime: DataTypes.Ts
    ]
end
