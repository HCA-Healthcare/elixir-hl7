defmodule HL7.Query do
  require Logger

  @moduledoc """
  Query HL7 Messages using Segment Grammar Notation.
  """

  @type t :: %HL7.Query{selections: list()}
  @type raw_hl7 :: String.t() | HL7.RawMessage.t()
  @type parsed_hl7 :: [list()] | HL7.Message.t()
  @type content_hl7 :: raw_hl7() | parsed_hl7()
  @type parsed_or_query_hl7 :: parsed_hl7() | HL7.Query.t()
  defstruct selections: []


  @doc """
  Selects an entire HL7 Message as an `HL7.Query`.
  """

  @spec select(parsed_hl7()) :: HL7.Query.t()
  def select(%HL7.Message{} = msg) do
    msg
    |> HL7.Message.get_segments()
    |> HL7.Query.select()
  end

  def select(msg) when is_list(msg) do
    full_selection = %HL7.Selection{segments: msg, complete: true, valid: true}
    %HL7.Query{selections: [full_selection]}
  end

  @doc """
  Selects or sub-selects segment groups in an HL7 Message using Segment Grammar Notation.
  """
  #
  #  @spec select(binary(), binary()) :: HL7.Query.t()
  #  def select(msg, schema) when is_binary(msg) and is_binary(schema) do
  #    HL7.Query.select(msg) |> HL7.Query.select(schema)
  #  end

  @spec select(parsed_or_query_hl7(), binary()) :: HL7.Query.t()
  def select(msg, schema) when is_list(msg) and is_binary(schema) do
    HL7.Query.select(msg) |> HL7.Query.select(schema)
  end

  def select(%HL7.Message{} = msg, schema) when is_binary(schema) do
    HL7.Query.select(msg) |> HL7.Query.select(schema)
  end

  def select(%HL7.Query{selections: selections}, schema) when is_binary(schema) do
    grammar = HL7.SegmentGrammar.new(schema)

    sub_selections =
      selections
      |> Enum.map(&get_selections_within_a_selection(&1, grammar))
      |> List.flatten()

    %HL7.Query{selections: sub_selections}
  end

  @doc """
  Filters currently selected selections (without deleting content) in an `HL7.Query`. The supplied `func`
  should accept an `HL7.Query` containing a single segment group and return a boolean.
  """

  @spec filter(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def filter(%HL7.Query{selections: selections}, func) when is_function(func) do

    modified_selections =
      selections
      |> Enum.map(fn m ->
        q = %HL7.Query{selections: [m]}
        if !func.(q), do: deselect_selection(m), else: m
        end)

    %HL7.Query{selections: modified_selections}
  end

  @doc """
  Rejects currently selected selections (without deleting content) in an `HL7.Query`. The supplied `func`
  should accept an `HL7.Query` containing a single segment group and return a boolean.
  """
  @spec reject(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def reject(%HL7.Query{selections: selections}, func) when is_function(func) do

    modified_selections =
      selections
      |> Enum.map(fn m ->
        q = %HL7.Query{selections: [m]}
        if func.(q), do: deselect_selection(m), else: m
      end)
    %HL7.Query{selections: modified_selections}
  end


  @doc """
  Returns the number of selections found by the last `select` operation.
  """

  def get_selection_count(%HL7.Query{selections: selections}) do
    selections
    |> Enum.filter(fn m -> m.valid end)
    |> Enum.count()
  end

  @doc """
  Filters (deletes) segments within selections by whitelisting one or more segment types.
  Accepts either a segment name, list of acceptable names, or a function that takes an `HL7.Query`
  (containing one segment at a time) and returns a boolean filter value.
  """

  @spec filter_segments(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def filter_segments(%HL7.Query{selections: selections} = query, func) when is_function(func) do
    filtered_segment_selections =
      selections
      |> Enum.map(fn m ->
        filtered_segments =
          case m.valid do
            true ->
              Enum.filter(
                m.segments,
                fn segment ->
                  q = %HL7.Query{selections: [%HL7.Selection{m | segments: [segment]}]}
                  func.(q)
                end
              )

            false ->
              m.segments
          end

        %HL7.Selection{m | segments: filtered_segments}
      end)

    %HL7.Query{query | selections: filtered_segment_selections}
  end

  @spec filter_segments(HL7.Query.t(), binary()) :: HL7.Query.t()
  def filter_segments(%HL7.Query{} = query, tag) when is_binary(tag) do
    filter_segments(query, [tag])
  end

  @spec filter_segments(HL7.Query.t(), [binary()]) :: HL7.Query.t()
  def filter_segments(%HL7.Query{selections: selections} = query, tags) when is_list(tags) do
    filtered_segment_selections =
      selections
      |> Enum.map(fn m ->
        filtered_segments =
          Enum.filter(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)

        %HL7.Selection{m | segments: filtered_segments}
      end)

    %HL7.Query{query | selections: filtered_segment_selections}
  end

  @doc """
  Rejects (deletes) segments within selections by blacklisting one or more segment types.
  Accepts either a segment name, list of acceptable names, or a function that takes an `HL7.Query`
  (containing one segment at a time) and returns a boolean reject value.
  """

  @spec reject_segments(HL7.Query.t(), binary()) :: HL7.Query.t()
  def reject_segments(%HL7.Query{} = query, tag) when is_binary(tag) do
    reject_segments(query, [tag])
  end

  @spec reject_segments(HL7.Query.t(), [binary()]) :: HL7.Query.t()
  def reject_segments(%HL7.Query{selections: selections} = query, tags) when is_list(tags) do
    filtered_segment_selections =
      selections
      |> Enum.map(fn m ->
        filtered_segments =
          Enum.reject(m.segments, fn [<<t::binary-size(3)>> | _] -> t in tags end)

        %HL7.Selection{m | segments: filtered_segments}
      end)

    %HL7.Query{query | selections: filtered_segment_selections}
  end

  @spec reject_segments(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def reject_segments(%HL7.Query{selections: selections} = query, func) when is_function(func) do
    rejected_segment_selections =
      selections
      |> Enum.map(fn m ->
        rejected_segments =
          case m.valid do
            true ->
              Enum.reject(
                m.segments,
                fn segment ->
                  q = %HL7.Query{selections: [%HL7.Selection{m | segments: [segment]}]}
                  func.(q)
                end
              )

            false ->
              m.segments
          end

        %HL7.Selection{m | segments: rejected_segments}
      end)

    %HL7.Query{query | selections: rejected_segment_selections}
  end

  @doc """
  Rejects (deletes) Z-segments among _selected_ segments across all selections.
  """

  def reject_z_segments(%HL7.Query{} = query) do
    func = fn q ->
      get_segments(q)
      |> Enum.at(0)
      |> case do
        [<<segment_name::binary-size(3)>> | _] -> String.at(segment_name, 0) == "Z"
        _ -> false
      end
    end

    reject_segments(query, func)
  end

  @doc """
  Associates data with each selected selection. This data remains accessible to
  child selections.

  Each selection stores a map of data. The supplied `func` should
  accept an `HL7.Query` and return a map of key-values to be merged into the
  existing map of data.

  Selections automatically include the index of the current selection, i.e., `%{index: 5}`.
  For HL7 numbering, the index values begin at 1.

  """

  @spec data(HL7.Query.t(), (HL7.Query.t() -> map())) :: HL7.Query.t()
  def data(%HL7.Query{selections: selections} = query, func)
      when is_function(func) do
    associated_selections = associate_selections(selections, func, [])
    %HL7.Query{query | selections: associated_selections}
  end

  @doc """
  Returns a list containing an associated data map for each selection in the given `HL7.Query`.
  """
  def get_data(%HL7.Query{selections: selections}) do
    selections
    |> Enum.filter(fn m -> m.valid end)
    |> Enum.map(fn m -> m.data end)
  end

  @doc """
  Returns the associated key-value of the first (or only) selection for the given `HL7.Query`.
  """
  def get_datum(%HL7.Query{} = query, key, default \\ nil) do
    query
    |> get_data()
    |> case do
      [] -> default
      [datum | _] -> Map.get(datum, key, default)
    end
  end

  @doc """
  Returns the selection index of the first (or only) selection for the given `HL7.Query`.
  """
  def get_index(%HL7.Query{} = query) do
    query |> get_datum(:index)
  end

  @doc """
  Updates the set numbers in each segment's first field to be their respective selection indices.
  """
  def number_set_ids(%HL7.Query{} = query) do
    replace_parts(query, "1", fn q -> get_index(q) |> Integer.to_string() end)
  end

  @doc """
  Replaces all the selected segment part of all selected segments, iterating through each selection.
  """
  @spec replace_parts(HL7.Query.t(), String.t(), function() | String.t() | list()) ::
          HL7.Query.t()
  def replace_parts(%HL7.Query{selections: selections} = query, schema, func_or_value)
      when is_binary(schema) do
    indices = HL7.FieldGrammar.to_indices(schema)
    selection_transform = get_selection_transform(func_or_value, indices)
    replaced_selections = replace_parts_in_selections(selections, selection_transform, [])
    %HL7.Query{query | selections: replaced_selections}
  end

  @doc """
  Replaces all _selected_ segments, iterating through each selection. The given `func` should
  accept an `HL7.Query` (referencing a single selection) and return a list of segments
  (in parsed list format).
  """
  @spec replace(HL7.Query.t(), function()) :: HL7.Query.t()
  def replace(%HL7.Query{selections: selections} = query, func) when is_function(func) do
    replaced_selections = replace_selections(selections, func, [])
    %HL7.Query{query | selections: replaced_selections}
  end

  @doc """
  Prepends a segment or list of segments to the currently _selected_ segments in each selection.
  """

  @spec prepend(HL7.Query.t(), list()) :: HL7.Query.t()
  def prepend(%HL7.Query{selections: selections} = query, [<<_::binary-size(3)>> | _] = segment_data) do
    prepended_segment_selections =
      selections
      |> Enum.map(fn m ->
        prepended_segments = [segment_data | m.segments]
        %HL7.Selection{m | segments: prepended_segments}
      end)

    %HL7.Query{query | selections: prepended_segment_selections}
  end

  def prepend(%HL7.Query{selections: selections} = query, segment_list) when is_list(segment_list) do
    prepended_segment_selections =
      selections
      |> Enum.map(fn m ->
        prepended_segments = segment_list ++ m.segments
        %HL7.Selection{m | segments: prepended_segments}
      end)

    %HL7.Query{query | selections: prepended_segment_selections}
  end

  @doc """
  Appends a segment or segments to the currently _selected_ segments in each selection.
  """
  @spec append(HL7.Query.t(), list()) :: HL7.Query.t()
  def append(%HL7.Query{selections: selections} = query, [<<_::binary-size(3)>> | _] = segments) do
    appended_segment_selections =
      selections
      |> Enum.map(fn m ->
        appended_segments = [segments | m.segments |> Enum.reverse()] |> Enum.reverse()
        %HL7.Selection{m | segments: appended_segments}
      end)

    %HL7.Query{query | selections: appended_segment_selections}
  end

  def append(%HL7.Query{selections: selections} = query, segments) when is_list(segments) do
    appended_segment_selections =
      selections
      |> Enum.map(fn m ->
        appended_segments = m.segments ++ segments
        %HL7.Selection{m | segments: appended_segments}
      end)

    %HL7.Query{query | selections: appended_segment_selections}
  end

  @doc """
  Deletes all _selected_ selections.
  """
  @spec delete(HL7.Query.t()) :: HL7.Query.t()
  def delete(%HL7.Query{selections: selections} = query) do
    deleted_segment_selections =
      selections
      |> Enum.map(fn m -> %HL7.Selection{m | segments: []} end)

    %HL7.Query{query | selections: deleted_segment_selections}
  end

  @doc """
  Deletes _selected_ selections for which `func` returns true
  """
  @spec delete(HL7.Query.t(), function()) :: HL7.Query.t()
  def delete(%HL7.Query{selections: selections} = query, func) when is_function(func) do
    deleted_segment_selections =
      selections
      |> Enum.map(fn m ->
        q = %HL7.Query{selections: [m]}

        case func.(q) do
          true -> %HL7.Selection{m | segments: []}
          false -> m
        end
      end)

    %HL7.Query{query | selections: deleted_segment_selections}
  end

  @doc """
  Returns a list containing a list of _selected_ segments for each selection.
  """
  @spec get_segment_groups(HL7.Query.t()) :: [list()]
  def get_segment_groups(%HL7.Query{selections: selections}) do
    selections
    |> Enum.map(fn m -> m.segments end)
    |> Enum.reject(fn s -> s == [] end)
  end

  @doc """
  Returns the first _selected_ segment across all selections.
  """
  @spec get_segment(HL7.Query.t()) :: list() | nil
  def get_segment(%HL7.Query{selections: selections}) do
    selections
    |> Enum.at(0)
    |> case do
      nil -> nil
      m -> m.segments |> Enum.at(0)
    end
  end

  @doc """
  Returns a flattened list of _selected_ segments across all selections.
  """
  @spec get_segments(HL7.Query.t()) :: [list()]
  def get_segments(%HL7.Query{selections: selections}) do
    selections
    |> Enum.reduce([], fn m, acc ->
      Enum.reduce(m.segments, acc, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()
  end

  @doc """
  Returns a flattened list of _selected_ segment names across all selections.
  """
  @spec get_segment_names(HL7.Query.t()) :: [list()]
  def get_segment_names(%HL7.Query{} = query) do
    get_parts(query, "0")
  end

  @doc """
  Returns a flattened list of segment parts from _selected_ segments across all selections using
  the given field schema.

  `PID-3[2].1.2` PID segments, field 3, repetition 2, component 1, subcomponent 2

  `OBX-5` OBX segments, field 5

  `2.3` All segments, field 2, component 3

  """
  def get_parts(%HL7.Query{} = query, field_schema) do
    indices = HL7.FieldGrammar.to_indices(field_schema)

    query
    |> get_segments()
    |> HL7.Message.get_segment_parts(indices)
  end

  @doc """
  Returns a segment part from the first _selected_ segment (of the given name, if specified)
  across all selections using the given field schema.

  `PID-3[2].1.2` PID segments, field 3, repetition 2, component 1, subcomponent 2

  `OBX-5` OBX segments, field 5

  `2.3` All segments, field 2, component 3

  """
  def get_part(%HL7.Query{} = query, field_schema) do
    indices = HL7.FieldGrammar.to_indices(field_schema)

    query
    |> get_segments()
    |> HL7.Message.get_segment_part(indices)
  end

  @doc """
  Outputs an ANSI representation of an `HL7.Query` with corresponding selection indices on the left.
  """
  def to_console(%HL7.Query{selections: selections}) do
    import IO.ANSI

    selections
    |> Enum.map(fn m ->
      prefix =
        m.prefix |> Enum.map(fn segment -> default_color() <> "     " <> inspect(segment) end)

      segments =
        m.segments
        |> Enum.map(fn segment ->
          magenta() <>
            (Map.get(m.data, :index) |> to_string() |> String.pad_leading(3)) <>
            ": " <> green() <> inspect(segment)
        end)

      suffix = m.suffix |> Enum.map(fn segment -> default_color() <> inspect(segment) end)
      [prefix, segments, suffix]
    end)
    |> List.flatten()
    |> Enum.join("\n")
    |> IO.puts()
  end

  @doc """
  Converts an `HL7.Query` into an `HL7.Message`.
  """
  @spec to_message(HL7.Query.t()) :: HL7.Message.t()
  def to_message(%HL7.Query{} = query) do
    extract_lists_for_message(query) |> HL7.Message.new()
  end

  @doc """
  Selects the entire an `HL7.Query` into an `HL7.Message`.
  """
  @spec root(HL7.Query.t()) :: HL7.Query.t()
  def root(%HL7.Query{} = query) do
    extract_lists_for_message(query) |> HL7.Query.select()
  end

  ###############################
  ###    private functions    ###
  ###############################

  defp get_selections_within_a_selection(selection, grammar) do
    selection.segments
    |> build_selections(grammar, [])
    |> List.update_at(0, fn m -> %HL7.Selection{m | prefix: selection.prefix ++ m.prefix} end)
    |> List.update_at(-1, fn m -> %HL7.Selection{m | suffix: selection.suffix ++ m.suffix} end)
    |> Enum.map(fn m -> %HL7.Selection{m | valid: m.segments != []} end)
    |> index_selection_data()
  end

  defp index_selection_data(selections) do
    index_selection_data(selections, 1, [])
  end

  defp index_selection_data([selection | tail], index, result) do
    %HL7.Selection{data: data, valid: valid} = selection
    new_data = %{data | index: index}
    new_selection = %HL7.Selection{selection | data: new_data}
    new_index = if valid, do: index + 1, else: index
    index_selection_data(tail, new_index, [new_selection | result])
  end

  defp index_selection_data([], _, result) do
    result |> Enum.reverse()
  end

  defp build_selections([], _grammar, result) do
    result |> Enum.reverse()
  end

  defp build_selections(source, grammar, result) do
    selection = extract_first_selection(source, grammar)

    case selection do
      %HL7.Selection{complete: true, suffix: suffix} ->
        selection_minus_leftovers = %HL7.Selection{selection | suffix: []}
        build_selections(suffix, grammar, [selection_minus_leftovers | result])

      %HL7.Selection{complete: false} ->
        case result do
          [] ->
            [%HL7.Selection{prefix: source, broken: true}]

          [last_selection | tail] ->
            [%HL7.Selection{last_selection | suffix: source} | tail]
            |> Enum.reverse()
        end
    end
  end

  defp extract_first_selection(source, grammar) do
    head_selection = selection_from_head(grammar, %HL7.Selection{suffix: source})

    %HL7.Selection{
      head_selection
      | prefix: Enum.reverse(head_selection.prefix),
        segments: Enum.reverse(head_selection.segments)
    }
  end

  defp selection_from_head(_grammar, %HL7.Selection{suffix: []} = selection) do
    selection
  end

  defp selection_from_head(grammar, %HL7.Selection{} = selection) do
    head_selection = follow_grammar(grammar, selection)
    %HL7.Selection{complete: complete, prefix: prefix, suffix: suffix, broken: broken} = head_selection

    case complete && !broken do
      true ->
        head_selection

      false ->
        [segment | remaining_segments] = suffix

        selection_from_head(grammar, %HL7.Selection{
          head_selection
          | prefix: [segment | prefix],
            complete: false,
            broken: false,
            suffix: remaining_segments
        })
    end
  end

  defp follow_grammar(grammar, %HL7.Selection{suffix: []} = selection) when is_binary(grammar) do
    %HL7.Selection{selection | complete: false, broken: true}
  end

  defp follow_grammar(grammar, selection) when is_binary(grammar) do
    source = selection.suffix

    case grammar == next_segment_type(source) do
      true ->
        [segment | remaining_segments] = source

        %HL7.Selection{
          selection
          | complete: true,
            fed: true,
            segments: [segment | selection.segments],
            suffix: remaining_segments
        }

      false ->
        %HL7.Selection{selection | fed: false, broken: true}
    end
  end

  defp follow_grammar(%HL7.SegmentGrammar{repeating: true, optional: optional} = grammar, selection) do
    grammar_once = %HL7.SegmentGrammar{grammar | repeating: false}
    attempt_selection = %HL7.Selection{selection | complete: false}
    selectioned_once = follow_grammar(grammar_once, attempt_selection)

    case selectioned_once.complete && !selectioned_once.broken do
      true ->
        collect_copies(grammar, selectioned_once)

      false ->
        case optional do
          true -> %HL7.Selection{selectioned_once | complete: true}
          false -> %HL7.Selection{selection | complete: false}
        end
    end
  end

  defp follow_grammar(%HL7.SegmentGrammar{optional: optional} = grammar, selection) do
    attempt_selection = %HL7.Selection{selection | fed: false, complete: false, broken: false}

    children_selection =
      Enum.reduce_while(grammar.children, attempt_selection, fn child_grammar, current_selection ->
        child_selection = follow_grammar(child_grammar, current_selection)

        case child_selection.complete && !child_selection.broken do
          true ->
            {:cont, child_selection}

          false ->
            case optional do
              true ->
                {:cont, current_selection}

              false ->
                {:halt, %HL7.Selection{selection | complete: false, broken: true}}
            end
        end
      end)

    %HL7.Selection{children_selection | complete: !children_selection.broken}
  end

  defp collect_copies(%HL7.SegmentGrammar{} = grammar, selection) do
    grammar_once = %HL7.SegmentGrammar{grammar | repeating: false, optional: false}
    attempt_selection = %HL7.Selection{selection | complete: false}
    selectioned_once = follow_grammar(grammar_once, attempt_selection)

    case selectioned_once.fed && selectioned_once.complete && !selectioned_once.broken do
      true ->
        collect_copies(grammar, selectioned_once)

      false ->
        selection
    end
  end

  defp next_segment_type([[segment_type | _segment_data] | _tail_segments] = _source) do
    segment_type
  end

  defp replace_selections([%HL7.Selection{valid: false} = selection | tail], function, result) do
    replace_selections(tail, function, [selection | result])
  end

  defp replace_selections([%HL7.Selection{} = selection | tail], func, result) do
    query = %HL7.Query{selections: [selection]}
    replaced_segments = func.(query)
    new_selection = %HL7.Selection{selection | segments: replaced_segments}
    replace_selections(tail, func, [new_selection | result])
  end

  defp replace_selections([], _, result) do
    result |> Enum.reverse()
  end

  defp replace_parts_in_selections(
         [%HL7.Selection{valid: false} = selection | tail],
         selection_transform,
         result
       ) do
    replace_parts_in_selections(tail, selection_transform, [selection | result])
  end

  defp replace_parts_in_selections([%HL7.Selection{} = selection | tail], selection_transform, result) do
    query = %HL7.Query{selections: [selection]}
    replaced_segments = selection_transform.(query)
    new_selection = %HL7.Selection{selection | segments: replaced_segments}
    replace_parts_in_selections(tail, selection_transform, [new_selection | result])
  end

  defp replace_parts_in_selections([], _, result) do
    result |> Enum.reverse()
  end

  defp associate_selections([%HL7.Selection{valid: false} = selection | tail], func, result) do
    associate_selections(tail, func, [selection | result])
  end

  defp associate_selections([selection | tail], func, result) do
    %HL7.Selection{data: data} = selection
    query = %HL7.Query{selections: [selection]}
    assignments = func.(query)

    new_data =
      Map.merge(data, assignments, fn
        :index, v1, _v2 ->
          Logger.warn("HL7 data :index cannot be overwritten (used for selection position).")
          v1

        _, _, v2 ->
          v2
      end)

    new_selection = %HL7.Selection{selection | data: new_data}
    associate_selections(tail, func, [new_selection | result])
  end

  defp associate_selections([], _, result) do
    result |> Enum.reverse()
  end

  @spec extract_lists_for_message(HL7.Query.t()) :: [list()]
  defp extract_lists_for_message(%HL7.Query{selections: selections}) do
    # performant version of [prefix ++ segments ++ suffix]

    selections
    |> Enum.reduce([], fn m, acc ->
      with_prefixes = Enum.reduce(m.prefix, acc, fn s, s_acc -> [s | s_acc] end)
      with_segments = Enum.reduce(m.segments, with_prefixes, fn s, s_acc -> [s | s_acc] end)
      Enum.reduce(m.suffix, with_segments, fn s, s_acc -> [s | s_acc] end)
    end)
    |> Enum.reject(fn s -> s == [] end)
    |> Enum.reverse()
  end

  defp get_selection_transform(transform, indices) when is_function(transform) do
    fn query ->
      field_transform =
        cond do
          is_function(transform, 1) -> fn _current_value -> transform.(query) end
          is_function(transform, 2) -> fn current_value -> transform.(query, current_value) end
        end

      segments = query.selections |> Enum.at(0) |> Map.get(:segments)
      HL7.Message.update_segments(segments, indices, field_transform)
    end
  end

  defp get_selection_transform(transform_value, indices) do
    fn query ->
      field_transform = fn _current_value -> transform_value end
      segments = query.selections |> Enum.at(0) |> Map.get(:segments)
      HL7.Message.update_segments(segments, indices, field_transform)
    end
  end

  defp deselect_selection(%HL7.Selection{valid: false} = m) do
    m
  end

  defp deselect_selection(%HL7.Selection{valid: true, segments: segments, suffix: suffix} = m) do
    %HL7.Selection{m | segments: [], suffix: segments ++ suffix}
  end

end
