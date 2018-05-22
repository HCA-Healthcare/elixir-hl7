defmodule Hl7.V2_2.DataTypes.Cmgroupid do
  @moduledoc """
  The "CM_GROUP_ID" (CM_GROUP_ID) data type
  """

  use Hl7.DataType,
    fields: [
      unique_group_id: nil,
      placer_application_id: nil
    ]
end
