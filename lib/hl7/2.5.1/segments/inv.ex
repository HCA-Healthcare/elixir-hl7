defmodule Hl7.V2_5_1.Segments.INV do
  @moduledoc """
  HL7 segment data structure for "INV"
  """

  require Logger
  alias Hl7.V2_5_1.{DataTypes}

  use Hl7.Segment,
    fields: [
      segment: nil,
      substance_identifier: DataTypes.Ce,
      substance_status: DataTypes.Ce,
      substance_type: DataTypes.Ce,
      inventory_container_identifier: DataTypes.Ce,
      container_carrier_identifier: DataTypes.Ce,
      position_on_carrier: DataTypes.Ce,
      initial_quantity: nil,
      current_quantity: nil,
      available_quantity: nil,
      consumption_quantity: nil,
      quantity_units: DataTypes.Ce,
      expiration_date_time: DataTypes.Ts,
      first_used_date_time: DataTypes.Ts,
      on_board_stability_duration: DataTypes.Tq,
      test_fluid_identifiers: DataTypes.Ce,
      manufacturer_lot_number: nil,
      manufacturer_identifier: DataTypes.Ce,
      supplier_identifier: DataTypes.Ce,
      on_board_stability_time: DataTypes.Cq,
      target_value: DataTypes.Cq
    ]
end
