defmodule HL7.V2_4.DataTypes.Prl do
  @moduledoc false
  alias HL7.V2_4.{DataTypes}

  use HL7.DataType,
    fields: [
      obx3_observation_identifier_of_parent_result: DataTypes.Ce,
      obx4_subid_of_parent_result: nil,
      part_of_obx5_observation_result_from_parent: nil
    ]
end
