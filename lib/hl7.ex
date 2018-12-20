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

  def deidentify_hl7_smat_file(
        drop \\ 0,
        take \\ 1_000_000,
        input_file \\ "./temp/dev-smatfile-input.hl7",
        output_file \\ "./temp/dev-smatfile-output.hl7"
      ) do
    # Regex.split(~r/\{CONNID \d+\} \{IPVERSION \d\} \{CLIENTIP \S+\} {CLIENTPORT \S+}/, data)
    # Regex.split(~r/\{CONNID \d+\} \{IPVERSION \d\} \{CLIENTIP \S+\} {CLIENTPORT \S+}/, data, trim: true)

    began = :erlang.system_time()

    output_stream = File.stream!(output_file, [:write])

    # TODO: needs to use streaming
    raw = input_file |> File.read!()

    data =
      Regex.split(
        ~r/\s\S*\{CONNID \d+\} \{IPVERSION \d\} \{CLIENTIP \S+\} {CLIENTPORT \S+}/,
        raw,
        trim: true
      )

    input_stream =
      data
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&(&1 == ""))
      |> Stream.drop(drop)
      |> Stream.take(take)

    HL7Deidentify.stream(input_stream, output_stream)

    completed = :erlang.system_time()
    elapsed = (completed - began) / 1_000_000_000
    "Completed in #{elapsed} seconds."
  end


  def get_separators(<<"MSH", _::binary()>> = raw_message) do
    HL7.Separators.new(raw_message)
  end
end
