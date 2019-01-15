defmodule HL7.Query do
  require Logger

  defstruct matches: [], schema_history: []

  def new(msg) when is_binary(msg) do
    msg
    |> HL7.Message.get_lists()
    |> HL7.Query.new()
  end

  def new(%HL7.Message{} = msg) do
    msg
    |> HL7.Message.get_lists()
    |> HL7.Query.new()
  end

  def new(msg) when is_list(msg) do
    full_match = %HL7.Match{segments: msg, complete: true}
    %HL7.Query{matches: [[full_match]]}
  end

  def select(msg, schema) when is_binary(msg) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  def select(msg, schema) when is_list(msg) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  def select(%HL7.Message{} = msg, schema) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  def select(%HL7.Query{matches: [current_matches | parent_matches], schema_history: schema_history}, schema) do

    grammar = HL7.Grammar.new(schema)

    sub_matches =
      current_matches
      |> Enum.map(&get_matches_within_a_match(&1, grammar))
      |> List.flatten()

#    sub_matches_with_ids =
#      sub_matches
#      |> Enum.with_index()
#      |> Enum.map(fn {m, i} -> %HL7.Match{m | id: counter + i, complete: true, broken: false} end)
#
#    current_matches_with_child_ids =
#      current_matches
#      |> Enum.map(fn m ->
#        children =
#          sub_matches_with_ids
#          |> Enum.filter(fn sm -> sm.parent_id == m.id end)
#          |> Enum.map(fn sm -> sm.id end)
#        %HL7.Match{m | children: children}
#      end)

#    new_counter = counter + Enum.count(sub_matches_with_ids)
#    %HL7.Query{matches: [sub_matches_with_ids, current_matches_with_child_ids | parent_matches], counter: new_counter}
    %HL7.Query{matches: [sub_matches, current_matches | parent_matches], schema_history: [schema | schema_history]}
  end



  def filter(%HL7.Query{matches: [current_matches | parent_matches]} = query, tags) when is_list(tags) do
    filtered_segment_matches =
      current_matches
      |> Enum.map(fn m ->
        filtered_segments = Enum.filter(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)
        %HL7.Match{m | segments: filtered_segments}
      end)

    %HL7.Query{query | matches: [filtered_segment_matches | parent_matches]}
  end

  def reject(%HL7.Query{matches: [current_matches | parent_matches]} = query, tags) when is_list(tags) do
    filtered_segment_matches =
      current_matches
      |> Enum.map(fn m ->
        filtered_segments = Enum.reject(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)
        %HL7.Match{m | segments: filtered_segments}
      end)

    %HL7.Query{query | matches: [filtered_segment_matches | parent_matches]}
  end

  def data(%HL7.Query{matches: [current_matches | parent_matches]} = query, func) when is_function(func) do
    associated_matches =
      associate_matches(current_matches, func, [])

    %HL7.Query{query | matches: [associated_matches | parent_matches]}
  end

  def replace(%HL7.Query{matches: [current_matches | parent_matches]} = query, func) when is_function(func) do
    replaced_matches =
      replace_matches(current_matches, func, [])

    %HL7.Query{query | matches: [replaced_matches | parent_matches]}
  end

#  def replace(%HL7.Query{matches: [current_matches | parent_matches]} = query, tag, func) when is_function(func) do
#    replaced_matches =
#      replace_matches_with_tag(current_matches, tag, func, [])
#      |> Enum.reverse()
#    %HL7.Query{query | matches: [replaced_matches | parent_matches]}
#  end

#  defp replace_matches_with_tag([%HL7.Match{valid: false} = match | tail], tag, func, result) do
#    [match | replace_matches_with_tag(tail, tag, func, result)]
#  end
#
#  defp replace_matches_with_tag([match | tail], tag, func, result) do
#    replaced_segments = replace_segments_with_tag(match.segments, tag, func, 1, [])
#    new_match = %HL7.Match{match | segments: replaced_segments}
#    [new_match | replace_matches_with_tag(tail, tag, func, result)]
#  end
#
#  defp replace_matches_with_tag([], _, _, _, result) do
#    result
#  end

#  defp replace_segments_with_tag([segment | tail], tag, func, index, result) do
#    replaced_segment =
#      case Enum.at(segment, 0) == tag do
#        true -> func.(segment, index)
#        false -> segment
#      end
#
#    new_index = if replaced_segment == [], do: index, else: index + 1
#    new_match = %HL7.Match{match | segments: replaced_segments}
#    [new_match | replace_matches(tail, function, new_index, result)]
#  end

  defp replace_matches([%HL7.Match{valid: false} = match | tail], function, result) do
    replace_matches(tail, function, [match | result])
  end

  defp replace_matches([match | tail], function, result) do
    %HL7.Match{segments: segments, data: data} = match
    replaced_segments = function.(segments, data)
    new_match = %HL7.Match{match | segments: replaced_segments}
    replace_matches(tail, function, [new_match | result])
  end

  defp replace_matches([], _, result) do
    result |> Enum.reverse()
  end



  defp associate_matches([%HL7.Match{valid: false} = match | tail], function, result) do
    associate_matches(tail, function, [match | result])
  end

  defp associate_matches([match | tail], function, result) do
    %HL7.Match{segments: segments, data: data} = match
    new_data = Map.merge(data, function.(segments, data))
    new_match = %HL7.Match{match | data: new_data}
    associate_matches(tail, function, [new_match | result])
  end

  defp associate_matches([], _, result) do
    result |> Enum.reverse()
  end


  def delete(%HL7.Query{matches: [current_matches | parent_matches]} = query) do

    deleted_segment_matches =
      current_matches
      |> Enum.map(fn m -> %HL7.Match{m | segments: []} end)

    %HL7.Query{query | matches: [deleted_segment_matches | parent_matches]}

  end

  # todo -- add filter of tag list, filter of function(group, index) -- maybe filter() delete() back()?
#  def delete(%HL7.Query{matches: [current_matches | parent_matches]} = query, filter) do
#
#    deleted_segment_matches =
#      current_matches
#      |> Enum.map(fn m -> %HL7.Match{m | segments: []} end)
#
#    %HL7.Query{query | matches: [deleted_segment_matches | parent_matches]}
#
#  end

  def to_lists(%HL7.Query{matches: [current_matches | _parent_matches]}) do

    # performant version of [prefix ++ segments ++ suffix]

    current_matches
    |> Enum.reduce([], fn m, acc ->
      with_prefixes = Enum.reduce(m.prefix, acc, fn s, s_acc -> [s | s_acc] end)
      with_segments = Enum.reduce(m.segments, with_prefixes, fn s, s_acc -> [s | s_acc] end)
      Enum.reduce(m.suffix, with_segments, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()

  end

  def to_groups(%HL7.Query{matches: [current_matches | _parent_matches]}) do

    current_matches
    |> Enum.map(fn m -> m.segments end)
    |> Enum.reject(fn s -> s == [] end)

  end

  def to_segments(%HL7.Query{matches: [current_matches | _parent_matches]}) do

    current_matches
    |> Enum.reduce([], fn m, acc ->
      Enum.reduce(m.segments, acc, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()

  end

  def to_message(%HL7.Query{} = query) do
    to_lists(query) |> HL7.Message.new()
  end

  def get_matches_within_a_match(match, grammar) do

#      new_depth = match.depth + 1
#      parent_id = match.id

      match.segments
      |> build_matches(grammar, [])
      |> List.update_at(0, fn m -> %HL7.Match{m | prefix: match.prefix ++ m.prefix} end)
      |> List.update_at(-1, fn m -> %HL7.Match{m | suffix: match.suffix ++ m.suffix} end)
      |> Enum.map(fn m -> %HL7.Match{m | valid: m.segments != []} end)
#      |> Enum.map(fn m -> %HL7.Match{m | depth: new_depth, parent_id: parent_id} end)
      |> index_match_data()

  end

  defp index_match_data(matches) do
    index_match_data(matches, 1, [])
  end

  defp index_match_data([match | tail], index, result) do
    %HL7.Match{data: data, valid: valid} = match
    new_data = %{data | index: index}
    new_match = %HL7.Match{match | data: new_data}
    new_index = if valid, do: index + 1, else: index
    index_match_data(tail, new_index, [new_match | result])
  end

  defp index_match_data([], _, result) do
    result |> Enum.reverse()
  end


  def test() do
    m = HL7.Examples.wikipedia_sample_hl73() |> HL7.Message.parse() |> Map.get(:lists)
    HL7.Query.new(m)
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
    }
  end

  def match_from_head(_grammar, %HL7.Match{suffix: []} = match) do
    match
  end

  def match_from_head(grammar, %HL7.Match{} = match) do

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
    %HL7.Match{match | complete: false, broken: true}
  end

  def follow_grammar(grammar, match) when is_binary(grammar) do

    source = match.suffix

    case grammar == next_segment_type(source) do
      true ->

        [segment | remaining_segments] = source

        %HL7.Match{
          match
          | complete: true,
            fed: true,
            segments: [segment | match.segments],
            suffix: remaining_segments
        }

      false ->
        %HL7.Match{match | fed: false, broken: true}
    end
  end

  def follow_grammar(%HL7.Grammar{repeating: true, optional: optional} = grammar, match) do

    grammar_once = %HL7.Grammar{grammar | repeating: false}
    attempt_match = %HL7.Match{match | complete: false}
    matched_once = follow_grammar(grammar_once, attempt_match)

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


  def collect_copies(%HL7.Grammar{} = grammar, match) do

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


  defp next_segment_type([[segment_type | _segment_data] | _tail_segments] = _source) do
    segment_type
  end
end
