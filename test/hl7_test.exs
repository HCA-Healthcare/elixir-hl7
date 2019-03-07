defmodule HL7Test do
  use ExUnit.Case

  import HL7.TempFileCase
  use HL7.TempFileCase

  # ^K - VT (Vertical Tab) - 0x0B
  @sb "\v"
  # ^\ - FS (File Separator)
  @eb <<0x1C>>
  # ^M - CR (Carriage Return) - 0x0D
  @cr "\r"
  @ending @eb <> @cr

  doctest HL7

  test "Can open a good mllp message from file stream using file type inference" do
    filepath = tmp_path("wiki.hl7")
    wiki_hl7 = HL7.Examples.wikipedia_sample_hl7()
    File.write!(filepath, @sb <> wiki_hl7 <> @ending)
    assert wiki_hl7 == HL7.open_hl7_file_stream(filepath) |> Enum.at(0)
  end

  test "Can open a good message from file stream using file type inference" do
    filepath = tmp_path("wiki.hl7")
    wiki_hl7 = HL7.Examples.wikipedia_sample_hl7()
    File.write!(filepath, wiki_hl7)
    assert wiki_hl7 == HL7.open_hl7_file_stream(filepath) |> Enum.at(0)
  end

  test "Attempting to open a bogus file returns unrecognized_file_type type error when using file type inference" do
    filepath = tmp_path("not_really_hl7.hl7")
    File.write!(filepath, "NOT A REAL HL7 FILE.")
    assert {:error, :unrecognized_file_type} == HL7.open_hl7_file_stream(filepath)
  end

  test "Attempting to open a non-existent file returns {:error, :enoent} when using file type inference" do
    filepath = tmp_path("no_such_file.hl7")
    assert {:error, :enoent} == HL7.open_hl7_file_stream(filepath)
  end

  test "Attempting to open a non-existent file returns {:error, :enoent} for :mllp" do
    filepath = tmp_path("no_such_file.hl7")
    assert {:error, :enoent} == HL7.open_hl7_file_stream(filepath, :mllp)
  end
end
