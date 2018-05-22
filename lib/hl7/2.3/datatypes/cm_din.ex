defmodule Hl7.V2_3.DataTypes.Cmdin do
  @moduledoc """
  The "CM_DIN" (CM_DIN) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      date: DataTypes.Ts,
      institution_name: DataTypes.Ce
    ]
end
