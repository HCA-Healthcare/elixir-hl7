#! /usr/bin/env elixir

new_version =
  "VERSION"
  |> File.read!()
  |> String.trim()
  |> Version.parse!()
  |> (fn ver -> "#{ver.major}.#{ver.minor}.#{ver.patch + 1}" end).()

File.write("VERSION", new_version)
IO.puts("Version bumped to #{new_version}")
