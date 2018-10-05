defmodule HL7.V2_4.DataTypes.Xtn do
  @moduledoc false
  
  use HL7.DataType,
    fields: [
			"999_9999999_x99999c_any_text": nil,
			telecommunication_use_code: nil,
			telecommunication_equipment_type_id: nil,
			email_address: nil,
			country_code: nil,
			areacity_code: nil,
			phone_number: nil,
			extension: nil,
			any_text: nil
    ]
end
