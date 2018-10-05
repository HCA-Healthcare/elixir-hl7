defmodule HL7.V2_5_1.DataTypes.Sps do
  @moduledoc false
  alias HL7.V2_5_1.{DataTypes}

  use HL7.DataType,
    fields: [
			specimen_source_name_or_code: DataTypes.Cwe,
			additives: DataTypes.Cwe,
			specimen_collection_method: nil,
			body_site: DataTypes.Cwe,
			site_modifier: DataTypes.Cwe,
			collection_method_modifier_code: DataTypes.Cwe,
			specimen_role: DataTypes.Cwe
    ]
end
