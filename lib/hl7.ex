defmodule HL7 do
  @moduledoc """
  Functions for reading raw HL7 messages, splitting them into segments, and
  parsing them into HL7.Segments structures
  """
  require Logger

  def message(content) do
    case HL7.Message.new(content) do
      %HL7.Message{} = hl7_msg -> {:ok, hl7_msg}
      %HL7.InvalidMessage{} = hl7_invalid -> {:error, hl7_invalid}
    end
  end

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

      _default ->
        File.stream!(file_path)
    end
  end

  def open_hl7_file_stream(file_path, prefix, suffix) do
    _file_ref = File.open!(file_path, [:read])

    file_path
    |> File.stream!([], 32768)
    |> HL7.SplitStream.raw_to_messages(prefix, suffix)
  end

#  def get_separators(<<"MSH", _::binary()>> = raw_message) do
#    HL7.Separators.new(raw_message)
#  end
end
