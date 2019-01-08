defmodule HL7.Group do
  require Logger

  @segment_terminator "\r"

  defstruct grammar: nil,
            index: -1,
            data: nil,
            # groups or segments
            children: []
end
