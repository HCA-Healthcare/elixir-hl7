defmodule HL7.Query do
  require Logger

  @moduledoc """
  Query HL7 Messages using Segment Grammar Notation.
  """

  @type t :: %HL7.Query{matches: list()}

  defstruct matches: []

  @doc """
  Create a new HL7 Query.
  """

  @spec new(binary()) :: HL7.Query.t()
  def new(msg) when is_binary(msg) do
    msg
    |> HL7.Message.get_lists()
    |> HL7.Query.new()
  end

  @spec new(HL7.Message.t()) :: HL7.Query.t()
  def new(%HL7.Message{} = msg) do
    msg
    |> HL7.Message.get_lists()
    |> HL7.Query.new()
  end

  @spec new([list()]) :: HL7.Query.t()
  def new(msg) when is_list(msg) do
    full_match = %HL7.Match{segments: msg, complete: true, valid: true}
    %HL7.Query{matches: [full_match]}
  end

  @doc """
  Selects or sub-selects segment groups in an HL7 Message using Segment Grammar Notation.
  """

  @spec select(binary(), binary()) :: HL7.Query.t()
  def select(msg, schema) when is_binary(msg) and is_binary(schema) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  @spec select([list()], binary()) :: HL7.Query.t()
  def select(msg, schema) when is_list(msg) and is_binary(schema) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  @spec select(HL7.Message.t(), binary()) :: HL7.Query.t()
  def select(%HL7.Message{} = msg, schema) when is_binary(schema) do
    HL7.Query.new(msg) |> HL7.Query.select(schema)
  end

  @spec select(HL7.Query.t(), binary()) :: HL7.Query.t()
  def select(%HL7.Query{matches: matches}, schema) when is_binary(schema) do
    grammar = HL7.Grammar.new(schema)

    sub_matches =
      matches
      |> Enum.map(&get_matches_within_a_match(&1, grammar))
      |> List.flatten()

    %HL7.Query{matches: sub_matches}
  end

  @doc """
  Filters segments within selections by whitelisting one or more segment types.
  """

  @spec filter(HL7.Query.t(), binary()) :: HL7.Query.t()
  def filter(%HL7.Query{} = query, tag) when is_binary(tag) do
    filter(query, [tag])
  end

  @spec filter(HL7.Query.t(), [binary()]) :: HL7.Query.t()
  def filter(%HL7.Query{matches: matches} = query, tags) when is_list(tags) do
    filtered_segment_matches =
      matches
      |> Enum.map(fn m ->
        filtered_segments =
          Enum.filter(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)

        %HL7.Match{m | segments: filtered_segments}
      end)

    %HL7.Query{query | matches: filtered_segment_matches}
  end

  @doc """
  Rejects segments within selections by blacklisting one or more segment types.
  """
  @spec reject(HL7.Query.t(), binary()) :: HL7.Query.t()
  def reject(%HL7.Query{} = query, tag) when is_binary(tag) do
    reject(query, [tag])
  end

  @spec reject(HL7.Query.t(), [binary()]) :: HL7.Query.t()
  def reject(%HL7.Query{matches: matches} = query, tags) when is_list(tags) do
    filtered_segment_matches =
      matches
      |> Enum.map(fn m ->
        filtered_segments =
          Enum.reject(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)

        %HL7.Match{m | segments: filtered_segments}
      end)

    %HL7.Query{query | matches: filtered_segment_matches}
  end

  @doc """
  Associates key-values with each selection -- carried forward
  with further selections.

  Each selection stores a map containing assigned data.

  By default, this includes just the index of the current match, i.e., `%{index: 5}`.
  For HL7 numbering, the index values begin at 1.

  The first segment of type `tag` and the associated selection data are passed to the
  given function and the result is stored in the selection's data under the
  given key (`name`).
  """

  @spec data(HL7.Query.t(), binary(), function(), binary()) :: HL7.Query.t()
  def data(%HL7.Query{matches: matches} = query, key, func, tag)
      when is_binary(key) and is_function(func) and is_binary(tag) do
    associated_matches = associate_matches(matches, key, func, tag, [])
    %HL7.Query{query | matches: associated_matches}
  end

  def get(%HL7.Query{matches: matches}, key, default \\ nil) do
    case matches do
      [] -> default
      [%HL7.Match{data: data} | _] -> Map.get(data, key, default)
    end
  end

  def number_set_ids(%HL7.Query{} = query) do
    replace_field(query, "1", fn _v, q -> HL7.Query.get(q, :index) |> Integer.to_string() end)
  end

  @doc """
  Replaces all the selected segment part of all selected segments, iterating through each match.
  """
  @spec replace_field(HL7.Query.t(), String.t(), function() | String.t() | list()) ::
          HL7.Query.t()
  def replace_field(%HL7.Query{matches: matches} = query, schema, func)
      when is_binary(schema) and is_function(func) do

    # if a segment name is not specified as the first index, prepend 0 to choose the first and only segment
    indices = HL7.FieldGrammar.to_indices(schema)
    segment_transform = get_segment_transform(func, indices)
    replaced_matches = replace_field_in_matches(matches, segment_transform, [])
    %HL7.Query{query | matches: replaced_matches}
  end

  defp get_segment_transform(transform, indices) when is_function(transform) do
    fn query, segments ->
      field_transform =
        cond do
          is_function(transform, 1) -> fn current_value -> transform.(current_value) end
          is_function(transform, 2) -> fn current_value -> transform.(current_value, query) end
        end

      HL7.Message.update_segments(segments, indices, field_transform)
    end
  end

  @doc """
  Replaces all selected segments, iterating through each match.
  """
  @spec replace(HL7.Query.t(), function()) :: HL7.Query.t()
  def replace(%HL7.Query{matches: matches} = query, func) when is_function(func) do
    replaced_matches = replace_matches(matches, func, [])
    %HL7.Query{query | matches: replaced_matches}
  end

  @doc """
  Prepends one or more segments as list data to the selected segments.
  """
  @spec prepend(HL7.Query.t(), list()) :: HL7.Query.t()
  def prepend(%HL7.Query{matches: matches} = query, [<<_::binary-size(3)>> | _] = segment_data) do
    prepended_segment_matches =
      matches
      |> Enum.map(fn m ->
        prepended_segments = [segment_data | m.segments]
        %HL7.Match{m | segments: prepended_segments}
      end)

    %HL7.Query{query | matches: prepended_segment_matches}
  end

  def prepend(%HL7.Query{matches: matches} = query, segment_list) when is_list(segment_list) do

    prepended_segment_matches =
      matches
      |> Enum.map(fn m ->
        prepended_segments = segment_list ++ m.segments
        %HL7.Match{m | segments: prepended_segments}
      end)

    %HL7.Query{query | matches: prepended_segment_matches}
  end

  @doc """
  Appends one or more segment lists to the selected segments.
  """
  @spec append(HL7.Query.t(), list()) :: HL7.Query.t()
  def append(%HL7.Query{matches: matches} = query, [<<_::binary-size(3)>> | _] = segment_data) do
    appended_segment_matches =
      matches
      |> Enum.map(fn m ->
        appended_segments = [segment_data | (m.segments |> Enum.reverse)] |> Enum.reverse()
        %HL7.Match{m | segments: appended_segments}
      end)

    %HL7.Query{query | matches: appended_segment_matches}
  end

  def append(%HL7.Query{matches: matches} = query, segment_list) when is_list(segment_list) do

    appended_segment_matches =
      matches
      |> Enum.map(fn m ->
        appended_segments = m.segments ++ segment_list
        %HL7.Match{m | segments: appended_segments}
      end)

    %HL7.Query{query | matches: appended_segment_matches}
  end

  @doc """
  Deletes all selected segments.
  """
  @spec delete(HL7.Query.t()) :: HL7.Query.t()
  def delete(%HL7.Query{matches: matches} = query) do
    deleted_segment_matches =
      matches
      |> Enum.map(fn m -> %HL7.Match{m | segments: []} end)

    %HL7.Query{query | matches: deleted_segment_matches}
  end

  @spec to_lists(HL7.Query.t()) :: [list()]
  def to_lists(%HL7.Query{matches: matches}) do
    # performant version of [prefix ++ segments ++ suffix]

    matches
    |> Enum.reduce([], fn m, acc ->
      with_prefixes = Enum.reduce(m.prefix, acc, fn s, s_acc -> [s | s_acc] end)
      with_segments = Enum.reduce(m.segments, with_prefixes, fn s, s_acc -> [s | s_acc] end)
      Enum.reduce(m.suffix, with_segments, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()
  end

  @spec to_groups(HL7.Query.t()) :: [list()]
  def to_groups(%HL7.Query{matches: matches}) do
    matches
    |> Enum.map(fn m -> m.segments end)
    |> Enum.reject(fn s -> s == [] end)
  end

  @spec to_segments(HL7.Query.t()) :: [list()]
  def to_segments(%HL7.Query{matches: matches}) do
    matches
    |> Enum.reduce([], fn m, acc ->
      Enum.reduce(m.segments, acc, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()
  end

  #  def to_segment_values(%HL7.Query{matches: matches}, field_schema) do
  #
  #  end

  @spec to_message(HL7.Query.t()) :: HL7.Message.t()
  def to_message(%HL7.Query{} = query) do
    to_lists(query) |> HL7.Message.new()
  end

  @spec root(HL7.Query.t()) :: HL7.Query.t()
  def root(%HL7.Query{} = query) do
    to_lists(query) |> HL7.Query.new()
  end

  defp get_matches_within_a_match(match, grammar) do
    match.segments
    |> build_matches(grammar, [])
    |> List.update_at(0, fn m -> %HL7.Match{m | prefix: match.prefix ++ m.prefix} end)
    |> List.update_at(-1, fn m -> %HL7.Match{m | suffix: match.suffix ++ m.suffix} end)
    |> Enum.map(fn m -> %HL7.Match{m | valid: m.segments != []} end)
    |> index_match_data()
  end

  defp get_first_segment_with_matching_tag(segments, tag) when is_list(segments) do
    segments
    |> Stream.filter(fn [<<t::binary-size(3)>> | _] -> t == tag end)
    |> Stream.take(1)
    |> Enum.at(0)
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

  defp build_matches([], _grammar, result) do
    result |> Enum.reverse()
  end

  defp build_matches(source, grammar, result) do
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

  defp extract_first_match(source, grammar) do
    head_match = match_from_head(grammar, %HL7.Match{suffix: source})

    %HL7.Match{
      head_match
      | prefix: Enum.reverse(head_match.prefix),
        segments: Enum.reverse(head_match.segments)
    }
  end

  defp match_from_head(_grammar, %HL7.Match{suffix: []} = match) do
    match
  end

  defp match_from_head(grammar, %HL7.Match{} = match) do
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

  defp follow_grammar(grammar, %HL7.Match{suffix: []} = match) when is_binary(grammar) do
    %HL7.Match{match | complete: false, broken: true}
  end

  defp follow_grammar(grammar, match) when is_binary(grammar) do
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

  defp follow_grammar(%HL7.Grammar{repeating: true, optional: optional} = grammar, match) do
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

  defp follow_grammar(%HL7.Grammar{optional: optional} = grammar, match) do
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

  defp collect_copies(%HL7.Grammar{} = grammar, match) do
    grammar_once = %HL7.Grammar{grammar | repeating: false, optional: false}
    attempt_match = %HL7.Match{match | complete: false}
    matched_once = follow_grammar(grammar_once, attempt_match)

    case matched_once.fed && matched_once.complete && !matched_once.broken do
      true ->
        collect_copies(grammar, matched_once)

      false ->
        match
    end
  end

  defp next_segment_type([[segment_type | _segment_data] | _tail_segments] = _source) do
    segment_type
  end

  defp replace_matches([%HL7.Match{valid: false} = match | tail], function, result) do
    replace_matches(tail, function, [match | result])
  end

  defp replace_matches([%HL7.Match{} = match | tail], func, result) do
    query = %HL7.Query{matches: [match]}
    replaced_segments = func.(query)
    new_match = %HL7.Match{match | segments: replaced_segments}
    replace_matches(tail, func, [new_match | result])
  end

  defp replace_matches([], _, result) do
    result |> Enum.reverse()
  end


  defp replace_field_in_matches(
         [%HL7.Match{valid: false} = match | tail],
         segment_transform,
         result
       ) do
    replace_field_in_matches(tail, segment_transform, [match | result])
  end

  defp replace_field_in_matches([%HL7.Match{} = match | tail], segment_transform, result) do
    query = %HL7.Query{matches: [match]}

    replaced_segments = segment_transform.(query, match.segments)
    new_match = %HL7.Match{match | segments: replaced_segments}
    replace_field_in_matches(tail, segment_transform, [new_match | result])
  end

  defp replace_field_in_matches([], _, result) do
    result |> Enum.reverse()
  end






  defp replace_each_segment_in_matches(
         [%HL7.Match{valid: false} = match | tail],
         segment_transform,
         result
       ) do
    replace_matches(tail, segment_transform, [match | result])
  end

  defp replace_each_segment_in_matches([%HL7.Match{} = match | tail], segment_transform, result) do
    query = %HL7.Query{matches: [match]}

    replaced_segments =
      match.segments
      |> Enum.map(fn segment -> segment_transform.(query, [segment]) end)

    new_match = %HL7.Match{match | segments: replaced_segments}
    replace_matches(tail, segment_transform, [new_match | result])
  end

  defp replace_each_segment_in_matches([], _, result) do
    result |> Enum.reverse()
  end

  defp associate_matches([%HL7.Match{valid: false} = match | tail], name, func, tag, result) do
    associate_matches(tail, name, func, tag, [match | result])
  end

  defp associate_matches([match | tail], name, func, tag, result) do
    %HL7.Match{segments: segments, data: data} = match
    tagged_segment = get_first_segment_with_matching_tag(segments, tag)

    new_data =
      case tagged_segment do
        nil -> data
        _ -> Map.put(data, name, func.(tagged_segment, data))
      end

    new_match = %HL7.Match{match | data: new_data}
    associate_matches(tail, name, func, tag, [new_match | result])
  end

  defp associate_matches([], _, _, _, result) do
    result |> Enum.reverse()
  end
end
