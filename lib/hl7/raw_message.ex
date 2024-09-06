defmodule HL7.RawMessage do
  require Logger

  @moduledoc """
  Contains the raw text of an HL7 message alongside parsed header metadata from the MSH segment.

  ## Examples

  Use `to_string()` to convert an HL7.Message struct into a string.
  iex(7)> HL7.Examples.nist_immunization_hl7() |> to_string() |> String.slice(1, 80)
  "SH|^~\\&|Test EHR Application|X68||NIST Test Iz Reg|201207010822||VXU^V04^VXU_V04"
  """

  @typedoc """
  Defines HL7.RawMessage struct
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
