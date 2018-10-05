defmodule HL7.V2_5.Segments.PCR do
  @moduledoc false

  require Logger
  alias HL7.V2_5.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      implicated_product: DataTypes.Ce,
      generic_product: nil,
      product_class: DataTypes.Ce,
      total_duration_of_therapy: DataTypes.Cq,
      product_manufacture_date: DataTypes.Ts,
      product_expiration_date: DataTypes.Ts,
      product_implantation_date: DataTypes.Ts,
      product_explantation_date: DataTypes.Ts,
      single_use_device: nil,
      indication_for_product_use: DataTypes.Ce,
      product_problem: nil,
      product_serial_lot_number: nil,
      product_available_for_inspection: nil,
      product_evaluation_performed: DataTypes.Ce,
      product_evaluation_status: DataTypes.Ce,
      product_evaluation_results: DataTypes.Ce,
      evaluated_product_source: nil,
      date_product_returned_to_manufacturer: DataTypes.Ts,
      device_operator_qualifications: nil,
      relatedness_assessment: nil,
      action_taken_in_response_to_the_event: nil,
      event_causality_observations: nil,
      indirect_exposure_mechanism: nil
    ]
end
