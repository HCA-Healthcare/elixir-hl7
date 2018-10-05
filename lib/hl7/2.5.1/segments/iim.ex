defmodule HL7.V2_5_1.Segments.IIM do
  @moduledoc false

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      primary_key_value_iim: DataTypes.Cwe,
      service_item_code: DataTypes.Cwe,
      inventory_lot_number: nil,
      inventory_expiration_date: DataTypes.Ts,
      inventory_manufacturer_name: DataTypes.Cwe,
      inventory_location: DataTypes.Cwe,
      inventory_received_date: DataTypes.Ts,
      inventory_received_quantity: nil,
      inventory_received_quantity_unit: DataTypes.Cwe,
      inventory_received_item_cost: DataTypes.Mo,
      inventory_on_hand_date: DataTypes.Ts,
      inventory_on_hand_quantity: nil,
      inventory_on_hand_quantity_unit: DataTypes.Cwe,
      procedure_code: DataTypes.Ce,
      procedure_code_modifier: DataTypes.Ce
    ]
end
