defmodule HL7.V2_3.DataTypes.Cmmoc do
  @moduledoc false
  alias HL7.V2_3.{DataTypes}

  use HL7.DataType,
    fields: [
      dollar_amount: DataTypes.Mo,
      charge_code: DataTypes.Ce
    ]
end
