defmodule HL7.RawMessage do
  require Logger

  @moduledoc """
  Contains the raw text of an HL7 message alongside parsed header metadata from the MSH segment.

  Use `HL7.Message.raw/1` to generate the `HL7.RawMessage` struct.
  """

  @type t :: %HL7.RawMessage{
          raw: nil | binary(),
          header: nil | HL7.Header.t()
        }

  defstruct raw: nil,
            header: nil

  defimpl String.Chars, for: HL7.RawMessage do
    require Logger

    def to_string(%HL7.RawMessage{raw: raw_text}) do
      raw_text
    end
  end
end
