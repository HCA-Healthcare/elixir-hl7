defmodule HL7.InvalidHeader do
  @moduledoc false

  # Contains information concerning any failed attempt to parse an HL7 MSH segment.

  @type t :: %HL7.InvalidHeader{
          raw: nil | String.t(),
          reason: nil | atom()
        }

  defstruct raw: nil,
            reason: nil
end
