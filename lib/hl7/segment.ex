defmodule HL7.Segment do
  require Logger

  @moduledoc """
  Filter, parse and modify individual HL7 segments and their fragments.
  """

  @type raw_hl7 :: String.t() | HL7.RawMessage.t()
  @type fragment_hl7 :: String.t() | [list() | String.t()]
  @type segment_hl7 :: [fragment_hl7()]
  @type parsed_hl7 :: [segment_hl7()] | HL7.Message.t()
  @type content_hl7 :: raw_hl7() | parsed_hl7()

  @doc ~S"""
  Updates content within a parsed HL7 segment, returning a modified segment whose data has been transformed at the given 
  indices (starting at 1 as with HL7's convention). The `transform` can be either a `string`, `list` or `fn old_data -> new_data`.
  """

  @spec replace_part(
          segment_hl7(),
          fragment_hl7() | (fragment_hl7() -> fragment_hl7()),
          pos_integer(),
          pos_integer() | nil,
          pos_integer() | nil,
          pos_integer() | nil
        ) :: segment_hl7() | String.t()

  def replace_part(
        segment,
        transform,
        field,
        repetition \\ nil,
        component \\ nil,
        subcomponent \\ nil
      )

  def replace_part(segment, transform, field, repetition, component, subcomponent)
      when is_integer(field) and is_function(transform, 1) do
    indices = to_indices(field, repetition, component, subcomponent)
    replace_fragment(segment, indices, transform, true)
  end

  def replace_part(segment, transform, field, repetition, component, subcomponent)
      when is_integer(field) and (is_binary(transform) or is_list(transform)) do
    indices = to_indices(field, repetition, component, subcomponent)
    replace_fragment(segment, indices, fn _data -> transform end, true)
  end

  @doc false

  # used by HL7.Message to update segments with list-based indices

  @spec replace_fragment(list() | String.t(), list(), function(), boolean()) ::
          list() | String.t()
  def replace_fragment(data, [], transform, is_field) when is_function(transform, 1) do
    transform.(data) |> unwrap_binary_field(is_field)
  end

  def replace_fragment(data, [i | remaining_indices], transform, is_field)
      when is_binary(data) and is_integer(i) and is_function(transform, 1) do
    [data | empty_string_list(i)]
    |> List.update_at(0, fn d ->
      replace_fragment(d, remaining_indices, transform, false) |> unwrap_binary_field(is_field)
    end)
    |> Enum.reverse()
  end

  def replace_fragment(data, [i | remaining_indices], transform, is_field)
      when is_list(data) and is_integer(i) and is_function(transform, 1) do
    count = Enum.count(data)

    case i < count do
      true ->
        List.update_at(data, i, fn d ->
          replace_fragment(d, remaining_indices, transform, false)
          |> unwrap_binary_field(is_field)
        end)

      false ->
        data
        |> Enum.reverse()
        |> empty_string_list(i - count + 1)
        |> List.update_at(0, fn d ->
          replace_fragment(d, remaining_indices, transform, false)
          |> unwrap_binary_field(is_field)
        end)
        |> Enum.reverse()
    end
  end

  @doc false
  def get_part_by_indices(data, []) do
    data
  end

  def get_part_by_indices(data, [i | remaining_indices]) do
    case data do
      nil ->
        data

      _ when is_binary(data) ->
        data

      _ when is_integer(i) and is_list(data) ->
        Enum.at(data, i) |> get_part_by_indices(remaining_indices)
    end
  end

  @doc ~S"""
  Extracts content from a parsed HL7 segment,
  returning nested data by applying each supplied index in turn. Please note that HL7 indices start at 1.
  """

  @spec get_part(
          segment_hl7() | fragment_hl7(),
          field :: pos_integer(),
          repetition :: pos_integer() | nil,
          component :: pos_integer() | nil,
          subcomponent :: pos_integer() | nil
        ) :: nil | list() | binary()

  def get_part(data, field, repetition \\ nil, component \\ nil, subcomponent \\ nil)
      when is_integer(field) and
             (is_integer(repetition) or is_nil(repetition)) and
             (is_integer(component) or is_nil(component)) and
             (is_integer(subcomponent) or is_nil(subcomponent)) do
    indices = to_indices(field, repetition, component, subcomponent)
    get_part_by_indices(data, indices)
  end

  def leftmost_value([]) do
    nil
  end

  def leftmost_value([h | _]) do
    leftmost_value(h)
  end

  def leftmost_value(d) do
    d
  end

  @spec unwrap_binary_field(list() | String.t(), boolean()) :: list() | String.t()
  defp unwrap_binary_field([text], _is_field = true) when is_binary(text) do
    text
  end

  defp unwrap_binary_field(data, is_field) when is_boolean(is_field) do
    data
  end

  @spec empty_string_list(non_neg_integer()) :: [String.t()]
  defp empty_string_list(n) when is_integer(n) do
    empty_string_list([], n)
  end

  @spec empty_string_list([String.t()], non_neg_integer()) :: [String.t()]
  defp empty_string_list(list, 0) do
    list
  end

  defp empty_string_list(list, n) do
    empty_string_list(["" | list], n - 1)
  end

  defp to_indices(field, repetition, component, subcomponent) do
    [field + 1, repetition, component, subcomponent]
    |> Enum.take_while(fn i -> i != nil end)
    |> Enum.map(fn i -> i - 1 end)
  end
end
