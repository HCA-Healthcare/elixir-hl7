defmodule HL7.SegmentGrammar do
  require Logger

  @type t :: %HL7.SegmentGrammar{
          children: list(),
          optional: boolean(),
          repeating: boolean()
        }

  @type grammar_result :: HL7.SegmentGrammar.t() | HL7.InvalidGrammar.t()

  @moduledoc false

  defstruct children: [],
            optional: false,
            repeating: false

  # Selector strings should be HL7 segment grammar strings, e.g., "OBR {EVN} [{OBX [{NTE}]}]"

  @spec new(String.t()) :: grammar_result()
  def new(schema) do
    chunks = chunk_schema(schema)
    {g, _tail} = build_grammar(%HL7.SegmentGrammar{}, chunks)

    case g do
      %HL7.InvalidGrammar{} ->
        %HL7.InvalidGrammar{g | schema: schema}

      %HL7.SegmentGrammar{} ->
        case has_non_optional_children(g) do
          true -> g
          false -> %HL7.InvalidGrammar{reason: :no_required_segments}
        end
    end
  end

  @spec has_non_optional_children(HL7.SegmentGrammar.t()) :: boolean()
  def has_non_optional_children(%HL7.SegmentGrammar{} = g) do
    check_for_non_optional_children(g)
  end

  @spec check_for_non_optional_children(HL7.SegmentGrammar.t()) :: boolean()
  defp check_for_non_optional_children(%HL7.SegmentGrammar{optional: true}) do
    false
  end

  defp check_for_non_optional_children(%HL7.SegmentGrammar{children: children, optional: false}) do
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

  @spec build_grammar(HL7.SegmentGrammar.t(), [String.t()]) :: {grammar_result(), [String.t()]}
  defp build_grammar(grammar, [chunk | tail] = tokens) do
    case chunk do
      "{" ->
        {g, chunks} = build_grammar(%HL7.SegmentGrammar{repeating: true}, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.SegmentGrammar{} ->
            build_grammar(%HL7.SegmentGrammar{grammar | children: [g | grammar.children]}, chunks)
        end

      "[" ->
        {g, chunks} = build_grammar(%HL7.SegmentGrammar{optional: true}, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.SegmentGrammar{} ->
            build_grammar(%HL7.SegmentGrammar{grammar | children: [g | grammar.children]}, chunks)
        end

      " " ->
        build_grammar(grammar, tail)

      "}" ->
        {%HL7.SegmentGrammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      "]" ->
        {%HL7.SegmentGrammar{grammar | children: Enum.reverse(grammar.children)}, tail}

      <<tag::binary-size(3)>> ->
        g = %HL7.SegmentGrammar{grammar | children: [tag | grammar.children]}
        build_grammar(g, tail)

      _invalid_token ->
        {%HL7.InvalidGrammar{invalid_token: chunk, reason: :invalid_token}, []}
    end
  end

  defp build_grammar(grammar, []) do
    {%HL7.SegmentGrammar{grammar | children: Enum.reverse(grammar.children)}, []}
  end

  @spec chunk_schema(String.t()) :: [String.t()]
  def chunk_schema(schema) do
    Regex.split(~r{(\{|\[|\}|\]|\s)}, schema, include_captures: true, trim: true)
  end
end
