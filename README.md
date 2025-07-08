# Elixir HL7 

<!-- MDOC !-->

[![hex.pm version](https://img.shields.io/hexpm/v/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7) 
[![hex.pm downloads](https://img.shields.io/hexpm/dt/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)
[![hex.pm license](https://img.shields.io/hexpm/l/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)

An Elixir library for working with HL7 v2.x healthcare data 

Elixir HL7 provides functions to parse, query and modify healthcare data that conforms to the HL7 v2.x standards. 
It should be able to reconstruct any HL7 Message without data loss or corruption.

It also provides basic support for reading HL7 file streams with configurable delimiters (MLLP included). 

This library has been tested on a wide variety of real-world HL7 messages to ensure correctness and flexibility. 

Since many HL7 messages do not strictly conform to the standards specified for each version, the library does not
attempt to enforce limits such as character counts or structural expectations. 

In fact, HL7 uses implicit hierarchies within segments (by leaving out certain separators) and to group segments
(via expected patterns only known to the consuming application).


You can learn more about HL7 here:
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7)
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))

Please [report an issue](https://github.com/HCA-Healthcare/elixir-hl7/issues) if something appears to be handled incorrectly.

> ### Note {: .warning}
>
> We are building a simpler and more Elixir-friendly API for this library, centered on
> the `HL7` and `HL7.Path` modules. 
> 
> This new API replaces the `HL7.Query`, `HL7.Segment`, and `HL7.Message` modules. 
> 
> These will likely not be removed for some time, and their
> removal will coincide with a major version release. 
> 
> For now, the two systems can exchange data when needed.
> E.g., `hl7_text |> HL7.Message.new() |> HL7.new!()`

## Getting started

Add this library to your mix.exs file:

```elixir
defp deps do
  [{:elixir_hl7, "~> 0.10.0"}]
end
```

### Examples 

The `HL7.Examples` module contains functions with sample data that you can use to explore the API.

    iex> import HL7, only: :sigils
    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get(~p"MSH-9.1")
    "ADT" 

> ### Tip {: .tip}
> You can use the `to_string()` protocol implementation to render HL7 structs as text.

### Parse

HL7 messages can be fully parsed into lists of sparse maps and strings to provide a compact representation 
of the underlying message structure.

Use `new!` to parse raw HL7 into a struct and `get_segments/1` to view the parsed data.

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get_segments()
    ...> |> Enum.at(1)
    %{0 => "EVN", 2 => "200605290901", 6 => "200605290900"}

### Query

Use `get/2` with `sigil_p` to find HL7 data.

    iex> import HL7, only: :sigils
    iex> HL7.Examples.nist_immunization_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get(~p"RXA-5.2")
    "Influenza"
   
### Modify

Modify the data within messages, segments or repetitions using `put/3` and `update/4`:

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.put(~p"OBX[2]-5", "44")
    ...> |> HL7.get(~p"OBX[*]-5")
    ["1.80", "44"]

## Create


## Files

The `HL7` module contains utility functions to open file streams of HL7 message content with support for MLLP and standard `:line` storage. 
Other formats are somewhat supported by specifying expected prefix and suffix delimiters between messages.

## Networking

A separate library, Elixir-MLLP, exists to manage MLLP connections. MLLP is a simple protocol on top of TCP that is commonly used for sending and receiving HL7 messages. 

# License

Elixir HL7 source code is released under Apache 2 License. Check the LICENSE file for more information.
