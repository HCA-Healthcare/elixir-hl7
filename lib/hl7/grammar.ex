defmodule HL7.Grammar do
  require Logger

  @moduledoc false

  defstruct children: [],
            optional: false,
            repeating: false

  # "OBR {EVN} [{OBX [{NTE}]}]"
  def new(schema) do
    chunks = chunk_schema(schema)
    {g, _tail} = build_grammar(%HL7.Grammar{}, chunks)

    case g do
      %HL7.InvalidGrammar{} ->
        %HL7.InvalidGrammar{g | schema: schema}

      %HL7.Grammar{} ->
        case has_non_optional_children(g) do
          true -> g
          false -> %HL7.InvalidGrammar{reason: :no_required_segments}
        end
    end
  end

  def has_non_optional_children(%HL7.Grammar{} = g) do
    check_for_non_optional_children(g)
  end

  defp check_for_non_optional_children(%HL7.Grammar{optional: true}) do
    false
  end

  defp check_for_non_optional_children(%HL7.Grammar{children: children, optional: false}) do
    Enum.find(
      children,
      fn g ->
        case g do
          <<_::binary-size(3)>> ->
            true

          _ ->
            check_for_non_optional_children(g)
        end
      end
    )
    |> case do
      nil -> false
      false -> false
      _ -> true
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
        {%HL7.InvalidGrammar{invalid_token: chunk, reason: :invalid_token}, []}
    end
  end

  defp build_grammar(grammar, []) do
    {%HL7.Grammar{grammar | children: Enum.reverse(grammar.children)}, []}
  end

  def chunk_schema(schema) do
    Regex.split(~r{(\{|\[|\}|\]|\s)}, schema, include_captures: true, trim: true)
  end
end
