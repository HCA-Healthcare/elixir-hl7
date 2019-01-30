defmodule HL7.Header do
  @type t :: %HL7.Header{
          message_type: nil | binary(),
          trigger_event: nil | binary(),
          sending_facility: nil | binary(),
          sending_application: nil | binary(),
          message_date_time: nil | DateTime.t(),
          separators: nil | HL7.Separators.t(),
          hl7_version: nil | binary()
        }

  defstruct message_type: nil,
            trigger_event: nil,
            sending_facility: nil,
            sending_application: nil,
            message_date_time: nil,
            separators: nil,
            hl7_version: nil
end
