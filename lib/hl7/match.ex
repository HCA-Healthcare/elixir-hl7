defmodule HL7.Match do
  require Logger

  defstruct segments: [],
            prefix: [],
            suffix: [],
            index: 0,
            complete: false,
            broken: false,
            valid: false,
            fed: false
end
