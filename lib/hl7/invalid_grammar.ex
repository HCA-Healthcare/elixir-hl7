defmodule HL7.InvalidGrammar do
  @moduledoc deprecated: "Use HL7 instead."
  @type invalid_token :: %HL7.InvalidGrammar{
          invalid_token: String.t(),
          schema: String.t(),
          reason: :invalid_token
        }

  @type no_required_segments :: %HL7.InvalidGrammar{
          invalid_token: String.t(),
          schema: String.t(),
          reason: :no_required_segments
        }

  @type t :: invalid_token | no_required_segments

  defstruct invalid_token: nil, schema: nil, reason: nil

  @moduledoc deprecated: """
             Contains information concerning about failed attempt to parse Field or Segment
             Grammar Notations related to an invalid token
             """
  def invalid_token(token, schema) when is_binary(token) and is_binary(schema) do
    %HL7.InvalidGrammar{
      invalid_token: token,
      schema: schema,
      reason: :invalid_token
    }
  end

  @doc """
  Contains information concerning about failed attempt to parse Field or Segment
  Grammar Notations related to an invalid token.
  """
  def no_required_segments do
    %HL7.InvalidGrammar{
      reason: :no_required_segments
    }
  end
end
