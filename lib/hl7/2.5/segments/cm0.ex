defmodule HL7.V2_5.Segments.CM0 do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_cm0: nil,
      sponsor_study_id: DataTypes.Ei,
      alternate_study_id: DataTypes.Ei,
      title_of_study: nil,
      chairman_of_study: DataTypes.Xcn,
      last_irb_approval_date: nil,
      total_accrual_to_date: nil,
      last_accrual_date: nil,
      contact_for_study: DataTypes.Xcn,
      contacts_telephone_number: DataTypes.Xtn,
      contacts_address: DataTypes.Xad
    ]
end
