defmodule HL7.V2_5.DataTypes.Ddi do
  @moduledoc false
  alias HL7.V2_5.{DataTypes}

  use HL7.DataType,
    fields: [
			delay_days: nil,
			monetary_amount: DataTypes.Mo,
			number_of_days: nil
    ]
end
