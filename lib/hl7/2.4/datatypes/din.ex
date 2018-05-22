defmodule Hl7.V2_4.DataTypes.Din do
  @moduledoc """
  The "DIN" (DIN) data type
  """
  alias Hl7.V2_4.{DataTypes}

  use Hl7.DataType,
    fields: [
      date: DataTypes.Ts,
      institution_name: DataTypes.Ce
    ]
end
