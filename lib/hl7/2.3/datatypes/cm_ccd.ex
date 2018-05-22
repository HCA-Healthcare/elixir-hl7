defmodule Hl7.V2_3.DataTypes.Cmccd do
  @moduledoc """
  The "CM_CCD" (CM_CCD) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      when_to_charge_code: nil,
      datetime: DataTypes.Ts
    ]
end
