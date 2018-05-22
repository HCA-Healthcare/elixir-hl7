defmodule Hl7.V2_3.DataTypes.Cmmoc do
  @moduledoc """
  The "CM_MOC" (CM_MOC) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      dollar_amount: DataTypes.Mo,
      charge_code: DataTypes.Ce
    ]
end
