defmodule HL7.InvalidMessage do
  @moduledoc deprecated: "Use errors from `HL7` instead"

  @moduledoc """
  Contains information concerning any failed attempt
  to parse an HL7 message, generally MSH-related
  """

  @type t :: %HL7.InvalidMessage{
          raw: nil | String.t(),
          header: nil | HL7.InvalidHeader.t(),
          created_at: nil | DateTime.t(),
          reason: nil | atom()
        }

  defstruct raw: nil,
            header: nil,
            created_at: nil,
            reason: nil
end
