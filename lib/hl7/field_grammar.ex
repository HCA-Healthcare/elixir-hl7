defmodule HL7.FieldGrammar do
  @moduledoc deprecated: "Use `HL7` instead"
  @moduledoc "Represents an HL7 path."

  @doc deprecated: "Use `HL7.Path.new/1` instead"
  def to_indices(schema) do
    HL7.Path.new(schema)
  end
end
