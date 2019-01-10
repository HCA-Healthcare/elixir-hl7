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

  def select(%HL7.Query{matches: matches} = query, schema) do
    grammar = HL7.Grammar.new(schema)

    sub_matches =
      matches
      |> Enum.map(&get_matches_within_a_match(&1, grammar))
      |> List.flatten()
#      |> Enum.reduce([], fn this_match, prior_matches ->
#        last_match = List.first(prior_matches)
#        updated_match = update_match_indices(this_match, last_match)
#        [updated_match | prior_matches]
#      end)
#      |> Enum.reverse()

    %HL7.Query{matches: sub_matches}
  end

#  defp update_match_indices(this_match, nil) do
#
#    %HL7.Match{this_match | indices: [0 | this_match.indices]}
#  end
#
#  defp update_match_indices(this_match, last_match) do
#
##    Logger.warn("SCAN #{inspect(this_match.indices)} #{inspect(last_match.indices)}")
#
#    last_index = Enum.at(last_match.indices, 0) || 0
#
#    this_index =
#      case last_match.valid do
#        true -> last_index + 1
#        false -> last_index
#      end
#
#    %HL7.Match{this_match | indices: [this_index | this_match.indices]}
#  end

  def get_matches_within_a_match(match, grammar) do
    #    Logger.warn("grammar #{inspect(grammar)}")

      match.segments
      |> build_matches(grammar, [])
      |> List.update_at(0, fn m -> %HL7.Match{m | prefix: match.prefix ++ m.prefix} end)
      |> List.update_at(-1, fn m -> %HL7.Match{m | suffix: match.suffix ++ m.suffix} end)
      |> Enum.map(fn m -> %HL7.Match{m | valid: m.segments != []} end)
#      |> Enum.map(fn m -> %HL7.Match{m | indices: [0 | match.indices]} end)
      |> Enum.scan(fn m, last_m ->

        last_index = last_m.index
        use_index =
          case last_m.valid do
            true -> last_index + 1
            false -> last_index
          end

          %HL7.Match{m | index: use_index}
      end)

  end

  def test() do
    m = HL7.Examples.wikipedia_sample_hl73() |> HL7.Message.parse() |> Map.get(:lists)
    q = HL7.Query.new(m)
  end

  #  def build_matches(%HL7.Match{prefix: prefix, segments: segments, suffix: suffix} = match, grammar) do
  #
  #    matches = build_matches(segments, grammar, [])
  #    first_match =  List.first(matches)
  #    last_match = List.last(matches)
  #    first_match_plus_prefix =  %HL7.Match{first_match | prefix: match.prefix ++ first_match.prefix}
  #    last_match_plus_prefix = %HL7.Match{last_match | suffix: match.suffix ++ last_match.suffix}
  #    matches
  #    |> List.replace_at(0, first_match_plus_prefix)
  #    |> List.replace_at(-1, last_match_plus_prefix)
  #
  #  end

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
          [] ->
            [%HL7.Match{prefix: source, broken: true}]

          [last_match | tail] ->
            [%HL7.Match{last_match | suffix: source} | tail]
            |> Enum.reverse()
        end
    end
  end

  def extract_first_match(source, grammar) do
    head_match = match_from_head(grammar, %HL7.Match{suffix: source})

    %HL7.Match{
      head_match
      | prefix: Enum.reverse(head_match.prefix),
        segments: Enum.reverse(head_match.segments)
#        suffix: Enum.reverse(head_match.suffix)
    }
  end

  def match_from_head(_grammar, %HL7.Match{suffix: []} = match) do
    match
  end

  def match_from_head(grammar, %HL7.Match{prefix: orig_prefix, suffix: orig_suffix} = match) do
    IO.inspect("mf h")
    head_match = follow_grammar(grammar, match)
    %HL7.Match{complete: complete, prefix: prefix, suffix: suffix, broken: broken} = head_match

    case complete && !broken do
      true ->
        head_match

      false ->
        [segment | remaining_segments] = suffix

        match_from_head(grammar, %HL7.Match{
          head_match
          | prefix: [segment | prefix],
            complete: false,
            broken: false,
            suffix: remaining_segments
        })
    end
  end

  def follow_grammar(grammar, %HL7.Match{suffix: []} = match) when is_binary(grammar) do
    Logger.warn("out of segs!!")
    %HL7.Match{match | complete: false, broken: true}
  end

  def follow_grammar(grammar, match) when is_binary(grammar) do
    #    IO.inspect("binary g")
    #    IO.inspect(grammar)
    #    IO.inspect(match)

    #    Logger.warn("got BIN")
    source = match.suffix

    case grammar == next_segment_type(source) do
      true ->
        #        IO.inspect("SUCCESS match ---------")
        [segment | remaining_segments] = source

        result = %HL7.Match{
          match
          | complete: true,
            fed: true,
            segments: [segment | match.segments],
            suffix: remaining_segments
        }

        #        Logger.warn("bin is #{inspect(result)}")
        result

      false ->
        result = %HL7.Match{match | fed: false, broken: true}
        #        Logger.warn("bin BAD #{inspect(result)}")
        result
    end
  end

  def follow_grammar(%HL7.Grammar{repeating: true, optional: optional} = grammar, match) do
    #    Logger.warn("got repeating")
    #    IO.inspect("rep true")
    #    IO.inspect(grammar)
    #    IO.inspect(match)

    grammar_once = %HL7.Grammar{grammar | repeating: false}
    attempt_match = %HL7.Match{match | complete: false}
    matched_once = follow_grammar(grammar_once, attempt_match)

    #    IO.inspect("rep once")
    #    IO.inspect(matched_once)

    case matched_once.complete && !matched_once.broken do
      true ->
        collect_copies(grammar, matched_once)

      false ->
        case optional do
          true -> %HL7.Match{matched_once | complete: true}
          false -> %HL7.Match{match | complete: false}
        end
    end
  end

  def collect_copies(%HL7.Grammar{} = grammar, match) do
    #    Logger.warn("got CC")
    #
    #    Logger.warn(inspect(grammar))
    #    Logger.warn(inspect(match))

    grammar_once = %HL7.Grammar{grammar | repeating: false, optional: false}
    attempt_match = %HL7.Match{match | complete: false}
    matched_once = follow_grammar(grammar_once, attempt_match)

    case matched_once.fed && matched_once.complete && !matched_once.broken &&
           matched_once.suffix != [] do
      true ->
        collect_copies(grammar, matched_once)

      false ->
        match
    end
  end

  def follow_grammar(%HL7.Grammar{optional: optional} = grammar, match) do
    attempt_match = %HL7.Match{match | fed: false, complete: false, broken: false}

    children_match =
      Enum.reduce_while(grammar.children, attempt_match, fn child_grammar, current_match ->
        child_match = follow_grammar(child_grammar, current_match)

        case child_match.complete && !child_match.broken do
          true ->
            {:cont, child_match}

          false ->
            case optional do
              true ->
                {:cont, current_match}

              false ->
                {:halt, %HL7.Match{match | complete: false, broken: true}}
            end
        end
      end)

    %HL7.Match{children_match | complete: !children_match.broken}
  end

  defp next_segment_type([[segment_type | _segment_data] | _tail_segments] = _source) do
    segment_type
  end
end
