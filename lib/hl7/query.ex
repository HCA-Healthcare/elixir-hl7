defmodule HL7.Query do
  require Logger

  @moduledoc """
  Queries and modifies HL7 messages using Field and Segment Grammar Notations with a pipeline-friendly API and set-based
  operations.

  Similar to libraries such as jQuery and D3, `HL7.Query` is designed around the concept of selecting and sub-selecting
  elements (segments or segment groups) in an HL7 message. The full message context is retained in the `HL7.Query`
  struct so that messages can be modified piecemeal and then reconstructed as strings.

  In general, use `HL7.Query.select/2` with a segment grammar to select lists of segment groups.

  The segment grammar is written as a string of ordered segment names. Curly braces surround optional elements.
  Square brackets enclose repeating elements. These can be nested to create complex matches against specific schemas.

  For example, an ORU_R01 HL7 message's Order Group grammar could be written as:

  `\"[ORC] OBR {[NTE]} {[OBX {[NTE]}]}\"`.

  Note that this would look for OBRs, optionally preceded by an ORC, possibly followed by one or more NTEs, maybe followed
  again by one or more OBRs with their own optional NTE sets.

  To reference data within segments, there is a flexible Field Notation that can access fields, repetitions, components
  and sub-components across one or more segments. All indices start at one, and the repetition index defaults to one
  unless specified within brackets after the field number.

  Field Notation | Description
  ------------ | -------------
  `\"PID-11[2].4\"` | PID segments, 11th field, 2nd repetition, 4th component
  `\"OBX-2.2.1\"` | OBX segments, 2nd field, 2nd component, 1st sub-component
  `\"1\"` | All segments, 1st field
  `\"3[4].2\"` | All segments, 3rd field, 4th repetition, 2nd component

  """

  # todo add wildcard field grammar, e.g. PID-11[*] to grab all field repetitions

  @type t :: %HL7.Query{selections: list()}
  @type raw_hl7 :: String.t() | HL7.RawMessage.t()
  @type parsed_hl7 :: [list()] | HL7.Message.t()
  @type content_hl7 :: raw_hl7() | parsed_hl7()
  @type parsed_or_query_hl7 :: parsed_hl7() | HL7.Query.t()
  @type content_or_query_hl7 :: content_hl7() | HL7.Query.t()

  defstruct selections: [], invalid_message: nil, part: nil

  @doc """
  Selects an entire HL7 Message as an `HL7.Query`. This is implicitly carried out by other
  functions in this module. As it involves parsing an HL7 message, one should
  cache this query if invoked repeatedly.
  """

  @spec select(content_or_query_hl7()) :: HL7.Query.t()
  def select(%HL7.Message{} = msg) do
    msg
    |> HL7.Message.to_list()
    |> HL7.Query.select()
  end

  def select(%HL7.InvalidMessage{} = msg) do
    %HL7.Query{invalid_message: msg}
  end

  def select(msg) when is_list(msg) do
    full_selection = %HL7.Selection{segments: msg, complete: true, valid: true}
    %HL7.Query{selections: [full_selection]}
  end

  def select(msg) when is_binary(msg) do
    msg
    |> HL7.Message.new()
    |> HL7.Query.select()
  end

  def select(%HL7.Query{} = query) do
    query
  end

  @doc """
  Selects or sub-selects segment groups in an HL7 Message using Segment Grammar Notation.
  """

  @spec select(content_or_query_hl7(), binary()) :: HL7.Query.t()
  def select(msg, schema) when is_list(msg) and is_binary(schema) do
    HL7.Query.select(msg) |> HL7.Query.select(schema)
  end

  def select(msg, schema) when is_binary(msg) and is_binary(schema) do
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

  @doc ~S"""
  Filters the current selections (without deleting content) in an `HL7.Query`. The supplied `fun`
  should accept an `HL7.Query` containing a single sub-selection and return a boolean.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("OBX")
      ...> |> filter(fn q -> get_part(q, "1") != "1" end)
      ...> |> delete()
      ...> |> root()
      ...> |> get_segment_names()
      ["MSH", "PID", "ORC", "RXA", "RXR", "OBX", "ORC", "RXA", "ORC", "RXA", "RXR", "OBX"]


  """
  @spec filter(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def filter(%HL7.Query{selections: selections}, fun) when is_function(fun) do
    modified_selections =
      selections
      |> Enum.map(fn m ->
        q = %HL7.Query{selections: [m]}
        if !fun.(q), do: deselect_selection(m), else: m
      end)

    %HL7.Query{selections: modified_selections}
  end

  @doc ~S"""
  Rejects the current selections (without deleting content) in an `HL7.Query`. The supplied `fun`
  should accept an `HL7.Query` containing a single sub-selection and return a boolean.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("OBX")
      ...> |> reject(fn q -> get_part(q, "1") == "1" end)
      ...> |> delete()
      ...> |> root()
      ...> |> get_segment_names()
      ["MSH", "PID", "ORC", "RXA", "RXR", "OBX", "ORC", "RXA", "ORC", "RXA", "RXR", "OBX"]


  """
  @spec reject(HL7.Query.t(), (HL7.Query.t() -> as_boolean(term))) :: HL7.Query.t()
  def reject(%HL7.Query{selections: selections}, fun) when is_function(fun) do
    modified_selections =
      selections
      |> Enum.map(fn m ->
        q = %HL7.Query{selections: [m]}
        if fun.(q), do: deselect_selection(m), else: m
      end)

    %HL7.Query{selections: modified_selections}
  end

  @doc """
  Returns the current selection count.
  """

  @spec get_selection_count(HL7.Query.t()) :: non_neg_integer()
  def get_selection_count(%HL7.Query{selections: selections}) do
    selections
    |> Enum.filter(fn m -> m.valid end)
    |> Enum.count()
  end

  @doc ~S"""
  Filters (deletes) segments within selections by whitelisting one or more segment types.
  Accepts either a segment name, list of acceptable names, or a function that takes an `HL7.Query`
  (containing one sub-selected segment at a time) and returns a boolean filter value.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> filter_segments(["MSH", "PID", "ORC"])
      ...> |> root()
      ...> |> get_segment_names()
      ["MSH", "PID", "ORC", "ORC", "ORC"]

  """

  @spec filter_segments(content_or_query_hl7(), (HL7.Query.t() -> as_boolean(term))) ::
          HL7.Query.t()
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

  def filter_segments(content_hl7, fun) when is_function(fun) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.filter_segments(query, fun)
  end

  @spec filter_segments(content_or_query_hl7(), binary()) :: HL7.Query.t()
  def filter_segments(%HL7.Query{} = query, tag) when is_binary(tag) do
    filter_segments(query, [tag])
  end

  def filter_segments(content_hl7, tag) when is_binary(tag) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.filter_segments(query, [tag])
  end

  @spec filter_segments(content_or_query_hl7(), [binary()]) :: HL7.Query.t()
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

  def filter_segments(content_hl7, tags) when is_list(tags) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.filter_segments(query, tags)
  end

  @doc ~S"""
  Rejects (deletes) segments within selections by blacklisting one or more segment types.
  Accepts either a segment name, list of acceptable names, or a function that takes an `HL7.Query`
  (containing one sub-selected segment at a time) and returns a boolean reject value.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> reject_segments(["OBX", "RXA", "RXR"])
      ...> |> root()
      ...> |> get_segment_names()
      ["MSH", "PID", "ORC", "ORC", "ORC"]

  """

  @spec reject_segments(HL7.Query.t(), binary()) :: HL7.Query.t()
  def reject_segments(%HL7.Query{} = query, tag) when is_binary(tag) do
    reject_segments(query, [tag])
  end

  def reject_segments(content_hl7, tag) when is_binary(tag) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.reject_segments(query, tag)
  end

  @spec reject_segments(content_or_query_hl7(), [binary()]) :: HL7.Query.t()
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

  def reject_segments(content_hl7, tags) when is_list(tags) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.reject_segments(query, tags)
  end

  @spec reject_segments(content_or_query_hl7, (HL7.Query.t() -> as_boolean(term))) ::
          HL7.Query.t()
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

  def reject_segments(content_hl7, fun) when is_function(fun) do
    query = HL7.Query.select(content_hl7)
    HL7.Query.reject_segments(query, fun)
  end

  @doc """
  Rejects (deletes) Z-segments in all selections.
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

  @doc ~S"""
  Associates data with each selection. This data remains accessible to
  child selections.

  Each selection stores a map of data. The supplied `fun` should
  accept an `HL7.Query` and return a map of key-values to be merged into the
  existing map of data.

  Selections automatically include the index of the current selection, i.e., `%{index: 5}`.
  For HL7 numbering, the index values begin at 1.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("ORC RXA RXR {[OBX]}")
      ...> |> data(fn q -> %{order_num: get_part(q, "ORC-3.1")} end)
      ...> |> select("OBX")
      ...> |> replace_parts("6", fn q -> get_datum(q, :order_num) end)
      ...> |> root()
      ...> |> get_part("OBX-6")
      "IZ-783278"

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("ORC RXA RXR {[OBX]}")
      ...> |> data(fn q -> %{group_num: get_index(q)} end)
      ...> |> select("OBX")
      ...> |> replace_parts("6", fn q -> get_datum(q, :group_num) end)
      ...> |> root()
      ...> |> get_parts("OBX-6")
      [1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]

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
  @spec get_data(HL7.Query.t()) :: [map()]
  def get_data(%HL7.Query{selections: selections}) do
    selections
    |> Enum.filter(fn m -> m.valid end)
    |> Enum.map(fn m -> m.data end)
  end

  @doc """
  Returns the associated key-value of the first (or only) selection for the given `HL7.Query`.
  """
  @spec get_datum(HL7.Query.t(), any(), any()) :: any()
  def get_datum(%HL7.Query{} = query, key, default \\ nil) do
    query
    |> get_data()
    |> case do
      [] -> default
      [datum | _] -> Map.get(datum, key, default)
    end
  end

  @doc ~S"""
  Returns the selection index of the first (or only) selection for the given `HL7.Query`.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("ORC RXA RXR {[OBX]}")
      ...> |> map(fn q -> get_index(q) end)
      [1, 2]

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("ORC RXA RXR {[OBX]}")
      ...> |> select("OBX")
      ...> |> map(fn q -> get_index(q) end)
      [1, 2, 3, 4, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("OBX")
      ...> |> map(fn q -> get_index(q) end)
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

  """
  @spec get_index(HL7.Query.t()) :: non_neg_integer()
  def get_index(%HL7.Query{} = query) do
    query |> get_datum(:index)
  end

  @doc """
  Updates the set numbers in each segment's first field to be their respective selection indices.
  """
  @spec number_set_ids(HL7.Query.t()) :: HL7.Query.t()
  def number_set_ids(%HL7.Query{} = query) do
    replace_parts(query, "1", fn q -> get_index(q) |> Integer.to_string() end)
  end

  @doc ~S"""
  Replaces segment parts of all selected segments, iterating through each selection.
  A replacement function accepts an `HL7.Query` containing one selection with its
  `part` property set to the value found using the `field_schema`.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> replace_parts("OBX-3.2", fn q -> "TEST: " <> q.part end)
      ...> |> get_parts("OBX-3.2")
      ...> |> List.first()
      "TEST: Vaccine funding program eligibility category"

      iex> import HL7.Query
      iex> HL7.Examples.wikipedia_sample_hl7()
      ...> |> select("PID")
      ...> |> replace_parts("5.2", "UNKNOWN")
      ...> |> get_part("PID-5.2")
      "UNKNOWN"

  """

  @spec replace_parts(content_or_query_hl7(), String.t(), function() | String.t() | list()) ::
          HL7.Query.t()

  def replace_parts(%HL7.Query{selections: selections} = query, field_schema, func_or_value)
      when is_binary(field_schema) do
    indices = HL7.FieldGrammar.to_indices(field_schema)
    selection_transform = get_selection_transform(func_or_value, indices)
    replaced_selections = replace_parts_in_selections(selections, selection_transform, [])
    %HL7.Query{query | selections: replaced_selections}
  end

  def replace_parts(hl7_content, schema, func_or_value) when is_binary(schema) do
    query = HL7.Query.select(hl7_content)
    replace_parts(query, schema, func_or_value)
  end

  @doc """
  Replaces all segments in each selection. The given `fun` should
  accept an `HL7.Query` (referencing a single selection) and return a list of replacement segments
  (in parsed list format).
  """
  @spec replace(HL7.Query.t(), function()) :: HL7.Query.t()
  def replace(%HL7.Query{selections: selections} = query, fun) when is_function(fun) do
    replaced_selections = replace_selections(selections, fun, [])
    %HL7.Query{query | selections: replaced_selections}
  end

  @doc """
  Prepends a segment or list of segments to the segments in each of the current selections.
  """

  @spec prepend(HL7.Query.t(), list()) :: HL7.Query.t()
  def prepend(
        %HL7.Query{selections: selections} = query,
        [<<_::binary-size(3)>> | _] = segment_data
      ) do
    prepended_segment_selections =
      selections
      |> Enum.map(fn m ->
        prepended_segments = [segment_data | m.segments]
        %HL7.Selection{m | segments: prepended_segments}
      end)

    %HL7.Query{query | selections: prepended_segment_selections}
  end

  def prepend(%HL7.Query{selections: selections} = query, segment_list)
      when is_list(segment_list) do
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

  @doc ~S"""
  Maps across each selection with a `fun` that accepts an `HL7.Query`
  (handling one selection at a time) and returns a results list.

  ## Examples

      iex> import HL7.Query
      iex> HL7.Examples.nist_immunization_hl7()
      ...> |> select("RXA")
      ...> |> map(fn q -> get_part(q, "5.2") end)
      ["Influenza", "PCV 13", "DTaP-Hep B-IPV"]

  """

  @spec map(HL7.Query.t(), function()) :: list()
  def map(%HL7.Query{selections: selections}, fun) when is_function(fun) do
    selections
    |> Enum.filter(fn s -> s.valid end)
    |> Enum.map(fn s ->
      query = %HL7.Query{selections: [s]}
      fun.(query)
    end)
  end

  @doc """
  Deletes all selections.
  """
  @spec delete(HL7.Query.t()) :: HL7.Query.t()
  def delete(%HL7.Query{selections: selections} = query) do
    deleted_segment_selections =
      selections
      |> Enum.map(fn m -> %HL7.Selection{m | segments: []} end)

    %HL7.Query{query | selections: deleted_segment_selections}
  end

  @doc """
  Deletes selections for which `fun` returns true
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
  Returns a flattened list of segment names across all selections.
  """
  @spec get_segment_names(content_or_query_hl7()) :: [String.t()]
  def get_segment_names(%HL7.Query{} = query) do
    get_parts(query, "0")
  end

  def get_segment_names(content_hl7) do
    query = HL7.Query.select(content_hl7)
    get_segment_names(query)
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

    case indices do
      [<<segment_name::binary-size(3)>> | numeric_indices] ->
        query
        |> HL7.Query.get_segments()
        |> Enum.filter(fn [name | _] -> name == segment_name end)
        |> Enum.map(fn segment -> segment |> HL7.Segment.get_part_by_indices(numeric_indices) end)

      _ ->
        query
        |> HL7.Query.get_segments()
        |> Enum.map(fn segment -> segment |> HL7.Segment.get_part_by_indices(indices) end)
    end
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

    case indices do
      [<<segment_name::binary-size(3)>> | numeric_indices] ->
        query
        |> HL7.Query.get_segments()
        |> HL7.Message.find(segment_name)
        |> HL7.Segment.get_part_by_indices(numeric_indices)

      _ ->
        query
        |> HL7.Query.get_segments()
        |> List.first()
        |> HL7.Segment.get_part_by_indices(indices)
    end
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

  defimpl String.Chars, for: HL7.Query do
    require Logger

    @spec to_string(HL7.Query.t()) :: String.t()
    def to_string(%HL7.Query{} = q) do
      HL7.Query.to_message(q) |> Kernel.to_string()
    end
  end

  ###############################
  ###    private functions    ###
  ###############################

  defp get_selections_within_a_selection(selection, grammar) do
    selection.segments
    |> build_selections(grammar, [])
    |> List.update_at(0, fn m -> %HL7.Selection{m | prefix: selection.prefix ++ m.prefix} end)
    |> List.update_at(-1, fn m -> %HL7.Selection{m | suffix: selection.suffix ++ m.suffix} end)
    |> Enum.map(fn m -> %HL7.Selection{m | valid: m.segments != [], data: selection.data} end)
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

    %HL7.Selection{complete: complete, prefix: prefix, suffix: suffix, broken: broken} =
      head_selection

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

  defp follow_grammar(
         %HL7.SegmentGrammar{repeating: true} = grammar,
         selection
       ) do
    grammar_once = %HL7.SegmentGrammar{grammar | repeating: false}
    attempt_selection = %HL7.Selection{selection | complete: false}
    found_once = follow_grammar(grammar_once, attempt_selection)

    case found_once.complete && !found_once.broken do
      true ->
        collect_copies(grammar, found_once)
      false ->
        %HL7.Selection{selection | complete: false}
    end
  end

  defp follow_grammar(%HL7.SegmentGrammar{optional: optional} = grammar, selection) do
    attempt_selection = %HL7.Selection{selection | fed: false, complete: false, broken: false}

    children_selection =
      Enum.reduce_while(grammar.children, attempt_selection, fn child_grammar,
                                                                current_selection ->
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
    found_once = follow_grammar(grammar_once, attempt_selection)

    case found_once.fed && found_once.complete && !found_once.broken do
      true ->
        collect_copies(grammar, found_once)

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

  defp replace_parts_in_selections(
         [%HL7.Selection{} = selection | tail],
         selection_transform,
         result
       ) do
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
      field_transform = fn current_value ->
        query_with_part = %HL7.Query{query | part: current_value}
        transform.(query_with_part)
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
