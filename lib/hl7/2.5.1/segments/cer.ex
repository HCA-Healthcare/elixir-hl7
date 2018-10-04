defmodule HL7.V2_5_1.Segments.CER do
  @moduledoc """
  HL7 segment data structure for "CER"
  """

  require Logger
  alias HL7.V2_5_1.{DataTypes}

  use HL7.Segment,
    fields: [
      segment: nil,
      set_id_cer: nil,
      serial_number: nil,
      version: nil,
      granting_authority: DataTypes.Xon,
      issuing_authority: DataTypes.Xcn,
      signature_of_issuing_authority: DataTypes.Ed,
      granting_country: nil,
      granting_state_province: DataTypes.Cwe,
      granting_county_parish: DataTypes.Cwe,
      certificate_type: DataTypes.Cwe,
      certificate_domain: DataTypes.Cwe,
      subject_id: nil,
      subject_name: nil,
      subject_directory_attribute_extension_health_professional_data: DataTypes.Cwe,
      subject_public_key_info: DataTypes.Cwe,
      authority_key_identifier: DataTypes.Cwe,
      basic_constraint: nil,
      crl_distribution_point: DataTypes.Cwe,
      jurisdiction_country: nil,
      jurisdiction_state_province: DataTypes.Cwe,
      jurisdiction_county_parish: DataTypes.Cwe,
      jurisdiction_breadth: DataTypes.Cwe,
      granting_date: DataTypes.Ts,
      issuing_date: DataTypes.Ts,
      activation_date: DataTypes.Ts,
      inactivation_date: DataTypes.Ts,
      expiration_date: DataTypes.Ts,
      renewal_date: DataTypes.Ts,
      revocation_date: DataTypes.Ts,
      revocation_reason_code: DataTypes.Ce,
      certificate_status: DataTypes.Cwe
    ]
end
