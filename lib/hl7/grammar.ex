defmodule HL7.Grammar do
  require Logger

  defstruct children: [],
            optional: false,
            repeating: false

  def new(schema) do
    chunks = chunk_schema(schema)
    {g, tail} = build_grammar(%HL7.Grammar{}, chunks)

    case g do
      %HL7.InvalidGrammar{} -> %HL7.InvalidGrammar{g | schema: schema}
      %HL7.Grammar{} -> g
    end
  end

  defp build_grammar(grammar, [chunk | tail] = tokens) do
    case chunk do
      "[" ->
        {g, chunks} = build_grammar(%HL7.Grammar{repeating: true}, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.Grammar{} ->
            build_grammar(%HL7.Grammar{grammar | children: [g | grammar.children]}, chunks)
        end

      "{" ->
        {g, chunks} = build_grammar(%HL7.Grammar{optional: true}, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.Grammar{} ->
            build_grammar(%HL7.Grammar{grammar | children: [g | grammar.children]}, chunks)
        end

      " " ->
        build_grammar(grammar, tail)

      "]" ->
        {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      "}" ->
        {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      <<tag::binary-size(3)>> ->
        g = %HL7.Grammar{grammar | children: [tag | grammar.children]}
        build_grammar(g, tail)

      _invalid_token ->
        {%HL7.InvalidGrammar{invalid_token: chunk}, []}
    end
  end

  defp build_grammar(grammar, []) do
    {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, []}
  end

  def chunk_schema(schema) do
    Regex.split(~r{(\{|\[|\}|\]|\s)}, schema, include_captures: true, trim: true)
  end
end
