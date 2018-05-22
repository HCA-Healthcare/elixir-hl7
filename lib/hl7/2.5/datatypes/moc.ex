defmodule Hl7.V2_5.DataTypes.Moc do
  @moduledoc """
  The "MOC" (MOC) data type
  """
  alias Hl7.V2_5.{DataTypes}

  use Hl7.DataType,
    fields: [
      monetary_amount: DataTypes.Mo,
      charge_code: DataTypes.Ce
    ]
end
