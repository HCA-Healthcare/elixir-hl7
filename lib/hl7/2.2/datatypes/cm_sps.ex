defmodule Hl7.V2_2.DataTypes.Cmsps do
  @moduledoc """
  The "CM_SPS" (CM_SPS) data type
  """
  alias Hl7.V2_2.{DataTypes}

  use Hl7.DataType,
    fields: [
      specimen_source_name_or_code: DataTypes.Ce,
      additives: nil,
      freetext: nil,
      body_site: DataTypes.Ce,
      site_modifier: DataTypes.Ce
    ]
end
