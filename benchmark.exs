alias Benchee
alias HL7.Message
alias HL7.Examples

msg = Examples.wikipedia_sample_hl7()
alt = Examples.wikipedia_sample_hl7_alt_delimiters()
list = msg |> Message.to_list()

b = %{
#  "raw" => fn -> msg |> Message.raw() end,
runner: fn -> msg |> Message.new() end,
#  "map" => fn -> list |> HL7.Map.new() end
#  "new-copy" => fn -> msg |> Message.new(%{copy: true}) end,
#  "new-alt" => fn -> alt |> Message.new() end,
#  runner: fn -> msg |> Message.new() |> to_string() end
}

:erlperf.run(b, %{report: :full, sample_duration: 1_650, warmup: 5}) |> IO.inspect()

# raw = parsed header info,
# new = fully parsed with default delimiters
# new-alt = fully parsed with custom delimiters
# round-trip = fully parsed then back to text

# Name                ips        average  deviation         median         99th %

# with elixir 1.7.x

# raw             48.60 K       20.58 μs    ±38.76%          19 μs          42 μs
# new              8.73 K      114.54 μs    ±11.34%         111 μs         168 μs
# round-trip       6.17 K      162.17 μs    ±10.16%         159 μs      230.12 μs

# with erlang 22.0.7 and elixir 1.9.1

# raw              58.89 K       16.98 μs    ±54.32%          16 μs          37 μs
# new               8.91 K      112.26 μs    ±17.20%         108 μs         174 μs
# round-trip        6.49 K      154.11 μs    ±12.37%         151 μs         225 μs

# with erlang 24 elixir 1.12

# raw              61.83 K       16.17 μs    ±83.80%          15 μs          33 μs
# new               9.87 K      101.35 μs    ±15.06%          97 μs         150 μs
# round-trip        7.32 K      136.69 μs     ±9.41%         134 μs         191 μs

# with erlang 25 elixir 1.14.1
# with tokenizer hot path for default parsing (~6x faster new!)

# Name                 ips        average  deviation         median         99th %
# raw              72.73 K       13.75 μs    ±71.83%       12.91 μs       25.87 μs
# new              59.81 K       16.72 μs    ±30.01%       15.00 μs       35.00 μs
# round-trip       21.31 K       46.92 μs    ±18.10%       44.65 μs       78.95 μs
# new-alt          15.51 K       64.46 μs    ±14.07%       62.27 μs      102.61 μs

# with binary copy option

# raw              73.43 K       13.62 μs    ±62.71%       12.80 μs       25.18 μs
# new              55.93 K       17.88 μs    ±29.34%       15.83 μs       36.76 μs
# new-copy         47.44 K       21.08 μs    ±30.22%       19.14 μs       41.36 μs
# round-trip       20.40 K       49.02 μs    ±20.06%       46.53 μs       86.84 μs
# new-alt          15.64 K       63.95 μs    ±14.60%       61.53 μs      104.48 μs

# with latin1 conversion

# raw              75.87 K       13.18 μs   ±113.53%       12.36 μs       24.25 μs
# new              51.93 K       19.26 μs    ±28.73%       17.37 μs       38.47 μs
# new-copy         47.77 K       20.93 μs    ±29.84%       19.21 μs       39.15 μs
# round-trip       20.32 K       49.21 μs    ±18.52%       47.62 μs       80.37 μs
# new-alt          15.50 K       64.53 μs    ±12.32%       62.72 μs       97.16 μs


