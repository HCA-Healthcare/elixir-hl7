defmodule Hl7.V2_5_1.DataTypes.Uvc do
  @moduledoc """
  The "UVC" (UVC) data type
  """
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      value_code: DataTypes.Cne,
      value_amount: DataTypes.Mo
    ]
end
