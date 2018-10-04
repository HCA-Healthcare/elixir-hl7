defmodule HL7.V2_5_1.DataTypes.Moc do
  @moduledoc """
  The "MOC" (MOC) data type
  """
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
      monetary_amount: DataTypes.Mo,
      charge_code: DataTypes.Ce
    ]
end
