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

  @doc false

  @spec update_part(list() | String.t(), list(), function(), boolean()) :: list() | String.t()
  def update_part(data, [], transform, is_field) when is_function(transform) do
    transform.(data) |> unwrap_binary_field(is_field)
  end

  #  def update_part(_data, [], transform, is_field)
  #      when is_list(transform) or is_binary(transform) do
  #    transform |> unwrap_binary_field(is_field)
  #  end

  def update_part(data, [i | remaining_indices], transform, is_field)
      when is_binary(data) and is_integer(i) and is_function(transform) do
    [data | empty_string_list(i)]
    |> List.update_at(0, fn d ->
      update_part(d, remaining_indices, transform, false) |> unwrap_binary_field(is_field)
    end)
    |> Enum.reverse()
  end

  def update_part(data, [i | remaining_indices], transform, is_field)
      when is_list(data) and is_integer(i) and is_function(transform) do
    count = Enum.count(data)

    case i < count do
      true ->
        List.update_at(data, i, fn d ->
          update_part(d, remaining_indices, transform, false) |> unwrap_binary_field(is_field)
        end)

      false ->
        data
        |> Enum.reverse()
        |> empty_string_list(i - count + 1)
        |> List.update_at(0, fn d ->
          update_part(d, remaining_indices, transform, false) |> unwrap_binary_field(is_field)
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

      _ when is_nil(i) ->
        data

      _ when is_binary(data) ->
        data

      _ when is_integer(i) and is_list(data) ->
        Enum.at(data, i) |> get_part_by_indices(remaining_indices)
    end
  end

  @doc ~S"""
  Extracts content from a parsed HL7 segment or fragment thereof,
  returning nested data by applying each supplied index in turn.
  """

  @spec get_part(
          segment_hl7() | fragment_hl7(),
          i1 :: non_neg_integer(),
          i2 :: non_neg_integer() | nil,
          i3 :: non_neg_integer() | nil,
          i4 :: non_neg_integer() | nil
        ) :: nil | list() | binary()

  def get_part(data, i1, i2 \\ nil, i3 \\ nil, i4 \\ nil)
      when is_integer(i1) and
             (is_integer(i2) or is_nil(i2)) and
             (is_integer(i3) or is_nil(i3)) and
             (is_integer(i4) or is_nil(i4)) do
    get_part_by_indices(data, [i1, i2, i3, i4])
  end

  #  @doc false
  #  @spec get_value(segment_hl7() | fragment_hl7(), list()) :: nil | list() | binary()
  #  def get_value(data, indices) when is_list(indices) do
  #    apply(HL7.Message, :get_value, [data | indices])
  #  end

  @doc ~S"""
  Extracts a simple string from a parsed HL7 segment or fragment thereof,
  acting like a call to `HL7.Segment.get_part/5` with the default indices
  set to 0 such that the left-most nested term is returned.
  """

  @spec get_value(
          segment_hl7() | fragment_hl7(),
          i1 :: non_neg_integer(),
          i2 :: non_neg_integer(),
          i3 :: non_neg_integer(),
          i4 :: non_neg_integer()
        ) :: nil | list() | binary()
  def get_value(data, i1 \\ 0, i2 \\ 0, i3 \\ 0, i4 \\ 0) do
    get_part_by_indices(data, [i1, i2, i3, i4])
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
end
