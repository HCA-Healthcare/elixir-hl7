defmodule HL7.V2_2.DataTypes.Cmndl do
  @moduledoc """
  The "CM_NDL" (CM_NDL) data type
  """
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      interpreter_technician: nil,
      start_datetime: DataTypes.Ts,
      end_datetime: DataTypes.Ts,
      location: nil
    ]
end
