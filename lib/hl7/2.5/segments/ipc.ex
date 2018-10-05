defmodule HL7.V2_5.Segments.IPC do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
			accession_identifier: DataTypes.Ei,
			requested_procedure_id: DataTypes.Ei,
			study_instance_uid: DataTypes.Ei,
			scheduled_procedure_step_id: DataTypes.Ei,
			modality: DataTypes.Ce,
			protocol_code: DataTypes.Ce,
			scheduled_station_name: DataTypes.Ei,
			scheduled_procedure_step_location: DataTypes.Ce,
			scheduled_ae_title: nil
    ]
end
