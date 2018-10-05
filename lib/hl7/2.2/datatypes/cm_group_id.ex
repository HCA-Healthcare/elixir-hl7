defmodule HL7.V2_2.DataTypes.Cmgroupid do
  @moduledoc false

  use HL7.DataType,
    fields: [
      unique_group_id: nil,
      placer_application_id: nil
    ]
end
