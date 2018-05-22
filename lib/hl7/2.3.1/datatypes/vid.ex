defmodule Hl7.V2_3_1.DataTypes.Vid do
  @moduledoc """
  The "VID" (VID) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      version_id: nil,
      internationalization_code: DataTypes.Ce,
      international_version_id: DataTypes.Ce
    ]
end
