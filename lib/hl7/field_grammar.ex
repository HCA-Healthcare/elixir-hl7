defmodule HL7.FieldGrammar do
  @moduledoc deprecated: "Use HL7.Path.new/1 instead"

  @doc deprecated: "Use HL7.Path.new/1 instead"
  def to_indices(schema) do
    HL7.Path.new(schema)
  end
end
