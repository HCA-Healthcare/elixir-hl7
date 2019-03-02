defmodule HL7.InvalidMessage do
  @type t :: %HL7.InvalidMessage{
          raw: nil | String.t(),
          created_at: nil | DateTime.t(),
          problems: nil | list()
        }

  defstruct raw: nil,
            created_at: nil,
            problems: nil
end
