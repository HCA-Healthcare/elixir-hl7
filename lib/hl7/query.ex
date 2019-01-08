defmodule HL7.Query do
  require Logger

  defstruct matches: nil

  def new(segments) do
    %HL7.Query{matches: [%HL7.Match{segments: segments, complete: true}]}
  end

#  def select(%HL7.Query{matches: matches} = query, schema) when is_binary(schema) do
#
#    grammar = HL7.Grammar.new(schema)
#    new_matches =
#      matches
#      |> Enum.map(&get_matches_within_a_match(&1, grammar))
#      |> List.flatten()
#
#    %HL7.Query{header: segments}
#  end

  def select(query, schema) do
    grammar = HL7.Grammar.new(schema)
    get_matches_within_a_match(Enum.at(query.matches, 0), grammar)
  end

  def get_matches_within_a_match(match, grammar) do

    match.segments
    |> build_matches(grammar, [])
#    |> add_remnants_to_final_match()
#    |> Enum.reverse()
    # add post to last match segments

  end


  def build_matches([], _grammar, result) do
    result |> Enum.reverse()
  end

  def build_matches(source, grammar, result) do
    match = extract_first_match(source, grammar)
    case match do
      %HL7.Match{complete: true, suffix: suffix} ->
        match_minus_leftovers = %HL7.Match{match | suffix: []}
        build_matches(suffix, grammar, [match_minus_leftovers | result])
      %HL7.Match{complete: false} ->
        case result do
          [] -> [%HL7.Match{prefix: source, broken: true}]
          [last_match | tail]  ->
            [%HL7.Match{last_match | suffix: source} | tail]
            |> Enum.reverse()
        end
    end
  end


  def extract_first_match(source, grammar) do
    head_match = match_from_head(grammar, %HL7.Match{suffix: source})
    %HL7.Match{head_match |
      prefix: Enum.reverse(head_match.prefix),
      segments: Enum.reverse(head_match.segments)
    }
  end

  def match_from_head(_grammar, %HL7.Match{suffix: []} = match) do
    match
  end

  def match_from_head(grammar, match) do

    head_match = follow_grammar(grammar, match)
    %HL7.Match{complete: complete, prefix: prefix, suffix: suffix} = head_match
    case complete do
      true -> head_match
      false ->
        [segment | remaining_segments] = suffix
        match_from_head(grammar, %HL7.Match{head_match | prefix: [segment | prefix], suffix: remaining_segments})
    end
  end



  def follow_grammar(grammar, match) when is_binary(grammar) do

    source = match.suffix
    case grammar == next_segment_type(source) do
      true ->
        [segment | remaining_segments] = source
        %HL7.Match{match | complete: true, segments: [segment | match.segments], suffix: remaining_segments}
      false ->
        %HL7.Match{match | broken: true}
    end

  end

  def follow_grammar(%HL7.Grammar{repeating: true, optional: optional} = grammar, match) do

    grammar_once = %HL7.Grammar{grammar | repeating: false}
    matched_once = follow_grammar(grammar_once, match)

    case matched_once.complete do
      true ->
        # grab any additional repeating matches
        follow_grammar(grammar, matched_once)

      false ->
        case optional do
          true -> match
          false -> %HL7.Match{match | broken: true}
        end
    end

  end


  def follow_grammar(%HL7.Grammar{optional: true} = grammar, match) do

    Enum.reduce(grammar.children, match, fn child_grammar, current_match ->
      child_match = follow_grammar(child_grammar, current_match)
      case child_match.complete do
        true -> child_match
        false -> current_match
      end
    end)

  end

  def follow_grammar(%HL7.Grammar{optional: false} = grammar, match) do

    Enum.reduce_while(grammar.children, match, fn child_grammar, current_match ->
      child_match = follow_grammar(child_grammar, current_match)
      case child_match.complete do
        true -> {:cont, child_match}
        false -> {:halt, %HL7.Match{match | broken: true}}
      end
    end)

  end


  defp next_segment_type([[segment_type | _segment_data] | _tail_segments ] = _source) do
    IO.inspect("seg:")
    IO.inspect(segment_type)
    segment_type
  end




end
