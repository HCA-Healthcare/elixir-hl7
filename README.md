# Elixir HL7 

[![hex.pm version](https://img.shields.io/hexpm/v/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7) 
[![hex.pm downloads](https://img.shields.io/hexpm/dt/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)
[![hex.pm license](https://img.shields.io/hexpm/l/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)

An Elixir library for working with HL7 v2.x healthcare data. 

Elixir HL7 provides functions to parse, query and modify healthcare data that conforms to the HL7 v2.x standards. 
It should be able to reconstruct any HL7 message without data loss or corruption.

It also provides basic support for reading HL7 file streams with configurable delimiters (MLLP included). 

This library has been tested on a wide variety of real-world HL7 messages to ensure correctness and flexibility. 

Since many HL7 messages do not strictly conform to the standards specified for each version, the library does not
attempt to enforce limits such as character counts or structural expectations. 

In fact, HL7 uses implicit hierarchies within segments (by leaving out certain separators) and to group segments
(via expected patterns only known to the consuming application).

The majority of the API currently resides in the eponymous `HL7` module.

You can learn more about HL7 here:
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7)
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))

For the best experience, please view this documentation at [hex.pm](https://hexdocs.pm/elixir_hl7/readme.html).

Please [report an issue](https://github.com/HCA-Healthcare/elixir-hl7/issues) if something appears to be handled incorrectly.

> ### New HL7 API {: .warning}
>
> The new `HL7` module API replaces the `HL7.Query`, `HL7.Segment`, and `HL7.Message` modules. 
> 
> These will likely not be removed for some time, and their
> removal will coincide with a major version release. 
> 
> For now, the two systems can exchange data when needed.
> See [here](./HL7.html#module-migrating-from-hl7-message-and-hl7-query) for details!

## History

We originally downloaded the HL7 specifications and generated structs to represent all possible message variants.
Unfortunately, thousands of vendors and hospitals do NOT actually follow these specifications. 
It turned out to be a fool's errand.

We then created a library designed to loosely parse and manipulate HL7 documents. This worked quite well, but as
it took inspiration from jQuery and D3js, it did not mesh well with canonical Elixir. 

This is the third approach to this library. We've attempted to hew closely to the HL7 business domain terminology
while also simplifying the API such that its data structures are more compatible with core Elixir modules like Map and Enum.

## Installation

Add this library to your mix.exs file.

```elixir
defp deps do
  [{:elixir_hl7, "~> 0.10.0"}]
end
```

## Examples 

The `HL7.Examples` module contains functions with sample data that you can use to explore the API.

    iex> import HL7, only: :sigils
    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get(~p"MSH-9.1")
    "ADT" 

## Parse

HL7 messages can be fully parsed into lists of sparse maps and strings to provide a compact representation 
of the underlying message structure.

Use `HL7.new!/2` to parse raw HL7 into a struct and `HL7.get_segments/1` to view the parsed data.

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get_segments()
    ...> |> Enum.at(1)
    %{0 => "EVN", 2 => "200605290901", 6 => "200605290900"}

## Query

Use `HL7.get/2` with the `HL7.Path` struct (created using `HL7.sigil_p/2`) to query HL7 data.

    iex> import HL7, only: :sigils
    iex> HL7.Examples.nist_immunization_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.get(~p"RXA-5.2")
    "Influenza"
   
## Modify

Modify the data within messages, segments or repetitions using `HL7.put/3` and `HL7.update/4`.
Use the `HL7.Path` struct (created using `HL7.sigil_p/2`) to specify what to change.

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.new!()
    ...> |> HL7.put(~p"OBX[2]-5", "44")
    ...> |> HL7.get(~p"OBX[*]-5")
    ["1.80", "44"]

## Create

Use `HL7.new/2`, `HL7.new_segment/1` and `HL7.set_segments/2` to build HL7 messages from scratch.
Note: This API is currently being developed and extended.

## Files

The `HL7` module contains utility functions to open file streams of HL7 message content with support for MLLP and standard `:line` storage. 
Other formats are somewhat supported by specifying expected prefix and suffix delimiters between messages.

## Networking

A separate library, Elixir-MLLP, exists to manage MLLP connections. MLLP is a simple protocol on top of TCP that is commonly used for sending and receiving HL7 messages. 

# License

Elixir HL7 source code is released under Apache 2 License. Check the LICENSE file for more information.
