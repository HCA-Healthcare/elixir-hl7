defmodule HL7.V2_2.DataTypes.Cnphysician do
  @moduledoc """
  The "CN_PHYSICIAN" (CN_PHYSICIAN) data type
  """
  alias HL7.V2_2.{DataTypes}

  use HL7.DataType,
    fields: [
      physician_id: nil,
      familiy_name: nil,
      given_name: nil,
      middle_initial_or_name: nil,
      suffix_eg_jr_or_iii: nil,
      prefix_eg_dr: nil,
      degree_eg_md: nil,
      source_table_id: nil,
      adresse: DataTypes.Ad,
      telefon: nil,
      faxnummer: nil,
      onlinenummer: nil,
      email: nil
    ]
end
