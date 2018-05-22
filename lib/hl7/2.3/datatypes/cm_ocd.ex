defmodule Hl7.V2_3.DataTypes.Cmocd do
  @moduledoc """
  The "CM_OCD" (CM_OCD) data type
  """
  alias Hl7.V2_3.{DataTypes}

  use Hl7.DataType,
    fields: [
      occurrence_code: DataTypes.Ce,
      occurrence_date: nil
    ]
end
