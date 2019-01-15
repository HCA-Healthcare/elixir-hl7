
defmodule HL7.Match do
  @moduledoc false
  require Logger

  defstruct segments: [],
            prefix: [],
            suffix: [],
            data: %{index: 1},
            id: 0,
            complete: false,
            broken: false,
            valid: false,
            fed: false

end
