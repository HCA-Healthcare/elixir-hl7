defmodule Hl7.V2_3_1.DataTypes.Din do
  @moduledoc """
  The "DIN" (DIN) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      date: DataTypes.Ts,
      institution_name: DataTypes.Ce
    ]
end
