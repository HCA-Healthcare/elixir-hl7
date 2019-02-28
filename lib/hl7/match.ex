defmodule HL7.Match do
  @moduledoc false
  require Logger

  @type t :: %HL7.Match{
               segments: list(),
               prefix: list(),
               suffix: list(),
               data: map(),
               id: non_neg_integer(),
               complete: boolean(),
               broken: boolean(),
               valid: boolean(),
               fed: boolean()
             }

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
