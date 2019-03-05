defmodule HL7.InvalidMessage do

  @moduledoc """
  Contains information concerning any failed attempt to parse an HL7 message, generally MSH-related.
  """

  @type t :: %HL7.InvalidMessage{
          raw: nil | String.t(),
          created_at: nil | DateTime.t(),
          problems: nil | list()
        }

  defstruct raw: nil,
            created_at: nil,
            problems: nil
end
