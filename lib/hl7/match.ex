defmodule HL7.Match do
  require Logger

  defstruct segments: [],
            prefix: [],
            suffix: [],
            data: %{index: 1},
            id: 0,
            parent_id: 0,
            depth: 0,
            index: 0,
            children: [],
            complete: false,
            broken: false,
            valid: false,
            fed: false

end
