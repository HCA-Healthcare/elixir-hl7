ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()

defmodule HL7.TempFileCase do
  use ExUnit.CaseTemplate

  setup do
    File.mkdir_p!(tmp_path())
    on_exit(fn -> File.rm_rf(tmp_path()) end)
    :ok
  end

  def tmp_path() do
    Path.expand("../../tmp", __DIR__)
  end

  def tmp_path(extra) do
    Path.join(tmp_path(), extra)
  end
end
