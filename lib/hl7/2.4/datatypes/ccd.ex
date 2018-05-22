defmodule Hl7.V2_4.DataTypes.Ccd do
  @moduledoc """
  The "CCD" (CCD) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      when_to_charge_code: nil,
      datetime: DataTypes.Ts
    ]
end
