defmodule HL7 do
  @moduledoc """
  Utility functions to load HL7 files as local streams.
  """
  require Logger

  @doc false

  @type file_type_hl7 :: :mllp | :smat | :line

  @spec open_hl7_file_stream(String.t()) :: Enumerable.t()
  def open_hl7_file_stream(file_path) do
    file_ref = File.open!(file_path, [:read])
    first_three = IO.binread(file_ref, 3)
    File.close(file_ref)

    case first_three do
      <<"MSH">> ->
        File.stream!(file_path)

      <<0x0B, "M", "S">> ->
        file_path
        |> File.stream!([], 32768)
        |> HL7.MLLPStream.raw_to_messages()
    end
  end

  @doc """
  Opens an HL7 file stream of either `:mllp`, `:smat` or `:line`.
  """
  @spec open_hl7_file_stream(String.t(), file_type_hl7()) :: Enumerable.t()
  def open_hl7_file_stream(file_path, file_type) when is_atom(file_type) do
    _file_ref = File.open!(file_path, [:read])

    case file_type do
      :mllp ->
        file_path
        |> File.stream!([], 32768)
        |> HL7.MLLPStream.raw_to_messages()

      :smat ->
        file_path
        |> File.stream!([], 32768)
        |> HL7.SMATStream.raw_to_messages()

      _ ->
        File.stream!(file_path)
    end
  end

  @doc """
  Opens an HL7 file stream with the given prefix and suffix strings used as message delimiters.
  """
  @spec open_hl7_file_stream(String.t(), String.t(), Regex.t()) :: Enumerable.t()
  def open_hl7_file_stream(file_path, prefix, suffix) do
    _file_ref = File.open!(file_path, [:read])

    file_path
    |> File.stream!([], 32768)
    |> HL7.SplitStream.raw_to_messages(prefix, suffix)
  end
end
