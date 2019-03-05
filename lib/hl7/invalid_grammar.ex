defmodule HL7.InvalidGrammar do
  @moduledoc """
  Contains information concerning any failed attempt to parse Field or Segment Grammar Notations.
  """

  @type t :: %HL7.InvalidGrammar{
          invalid_token: nil | String.t(),
          schema: nil | String.t(),
          reason: atom()
        }

  defstruct invalid_token: nil, schema: nil, reason: nil
end
