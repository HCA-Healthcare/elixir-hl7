defmodule Hl7.V2_3_1.DataTypes.Sps do
  @moduledoc """
  The "SPS" (SPS) data type
  """
  alias Hl7.V2_3_1.{DataTypes}

  use Hl7.DataType,
    fields: [
      specimen_source_name_or_code: DataTypes.Ce,
      additives: nil,
      freetext: nil,
      body_site: DataTypes.Ce,
      site_modifier: DataTypes.Ce,
      collection_modifier_method_code: DataTypes.Ce,
      specimen_role: DataTypes.Ce
    ]
end
