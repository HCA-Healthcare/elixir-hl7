defmodule HL7.RawMessage do
  require Logger

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
