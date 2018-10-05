defmodule HL7.V2_5.DataTypes.Moc do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
      monetary_amount: DataTypes.Mo,
      charge_code: DataTypes.Ce
    ]
end
