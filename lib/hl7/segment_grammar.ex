defmodule HL7.SegmentGrammar do
  require Logger

  @type t :: %HL7.SegmentGrammar{
          children: list(String.t() | t()),
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
    {g, _tail} = build_grammar(%HL7.SegmentGrammar{}, schema, chunks)

    with %HL7.SegmentGrammar{} <- g do
      case has_required_children?(g) do
        true -> g
        false -> HL7.InvalidGrammar.no_required_segments()
      end
    end
  end

  @spec has_required_children?(HL7.SegmentGrammar.t()) :: boolean()
  def has_required_children?(%HL7.SegmentGrammar{} = g) do
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

  defp add_child(%HL7.SegmentGrammar{} = grammar, child) do
    %{grammar | children: [child | grammar.children]}
  end

  defp close_bracket(%HL7.SegmentGrammar{} = grammar) do
    %{grammar | children: Enum.reverse(grammar.children)}
  end

  @spec build_grammar(HL7.SegmentGrammar.t(), String.t(), [String.t()]) ::
          {HL7.SegmentGrammar.t() | HL7.InvalidGrammar.invalid_token(), [String.t()]}
  defp build_grammar(%HL7.SegmentGrammar{} = grammar, schema, [chunk | tail] = tokens) do
    case chunk do
      "{" ->
        {g, chunks} = build_grammar(%HL7.SegmentGrammar{repeating: true}, schema, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.SegmentGrammar{} ->
            grammar
            |> add_child(g)
            |> build_grammar(schema, chunks)
        end

      "[" ->
        {g, chunks} = build_grammar(%HL7.SegmentGrammar{optional: true}, schema, tail)

        case g do
          %HL7.InvalidGrammar{} ->
            {g, tokens}

          %HL7.SegmentGrammar{} ->
            grammar
            |> add_child(g)
            |> build_grammar(schema, chunks)
        end

      " " ->
        build_grammar(grammar, schema, tail)

      closing_bracket when closing_bracket in ~w(} ]) ->
        {close_bracket(grammar), tail}

      <<"!", tag::binary-size(3)>> ->
        not_tag = "!" <> tag

        wildcard = %HL7.SegmentGrammar{
          repeating: true,
          children: [
            %HL7.SegmentGrammar{optional: true, children: [not_tag]}
          ]
        }

        g = %{grammar | children: [wildcard | grammar.children]}
        build_grammar(g, schema, tail)

      <<tag::binary-size(3), "*">> ->
        not_tag = "!" <> tag

        wildcard = %HL7.SegmentGrammar{
          repeating: true,
          children: [
            %HL7.SegmentGrammar{optional: true, children: [not_tag]}
          ]
        }

        grammar
        |> add_child(tag)
        |> add_child(wildcard)
        |> build_grammar(schema, tail)

      <<tag::binary-size(3)>> ->
        grammar
        |> add_child(tag)
        |> build_grammar(schema, tail)

      _invalid_token ->
        {HL7.InvalidGrammar.invalid_token(chunk, schema), []}
    end
  end

  defp build_grammar(%HL7.SegmentGrammar{} = grammar, _schema, []) do
    {%HL7.SegmentGrammar{grammar | children: Enum.reverse(grammar.children)}, []}
  end

  @spec chunk_schema(String.t()) :: [String.t()]
  def chunk_schema(schema) do
    Regex.split(~r{(\{|\[|\}|\]|\s)}, schema, include_captures: true, trim: true)
  end
end
