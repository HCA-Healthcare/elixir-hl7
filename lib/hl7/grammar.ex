defmodule HL7.Grammar do
  require Logger

  defstruct children: [],
            optional: false,
            repeating: false

  def new(schema) do
    chunks = chunk_schema(schema)
    build_grammar(%HL7.Grammar{}, chunks)
  end

  defp build_grammar(grammar, [chunk | tail]) do

    case chunk do
      "[" ->
        {g, chunks} = build_grammar(%HL7.Grammar{repeating: true}, tail)
        build_grammar(%HL7.Grammar{grammar | children: [g | grammar.children]}, chunks)

      "{" ->
        {g, chunks} = build_grammar(%HL7.Grammar{optional: true}, tail)
        build_grammar(%HL7.Grammar{grammar | children: [g | grammar.children]}, chunks)

      " " ->
        build_grammar(grammar, tail)

      "]" ->
        {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      "}" ->
        {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      <<tag::binary-size(3)>> ->
        g = %HL7.Grammar{grammar | children: [tag | grammar.children]}
        build_grammar(g, tail)
    end
  end

  defp build_grammar(grammar, []) do
    %HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}
  end

  def chunk_schema(schema) do
    Regex.split(~r{(\{|\[|\}|\]|\s)}, schema, include_captures: true, trim: true)
  end
end
