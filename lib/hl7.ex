defmodule HL7 do
  @moduledoc """
  Functions for reading raw HL7 messages, splitting them into segments, and
  parsing them into HL7.Segments structures
  """
  require Logger

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
        |> HL7.MllpStream.raw_to_messages()
    end
  end

  def get_separators(<<"MSH", _::binary()>> = raw_message) do
    HL7.Separators.new(raw_message)
  end
end
