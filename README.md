# Elixir HL7 
[![hex.pm version](https://img.shields.io/hexpm/v/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7) 
[![hex.pm downloads](https://img.shields.io/hexpm/dt/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)
[![hex.pm license](https://img.shields.io/hexpm/l/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)

An Elixir library for working with HL7 v2.x healthcare data 

Elixir HL7 provides functions to parse, query and modify healthcare data that conforms to the HL7 v2.x standards. 
It should be able to reconstruct any HL7 Message without data loss or corruption.

It also provides basic support for reading HL7 file streams with configurable delimiters (MLLP and SMAT included). 

This library has been tested on a fairly wide variety of real-world HL7 messages to ensure correctness and flexibility. 

You can learn more about HL7 here:
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7) 

## Industry nomenclature

Elixir-HL7 supports Segment Grammar Notation to validate and find nested segment groups as well as a Field Notation 
similar to that used by other healthcare applications.

Due to the high variance in HL7 implementations, segment and message schemas are not strictly enforced.
Optional HL7 delimiters specified in the MSH segment are respected when parsing. 

Please [report an issue](https://github.com/HCA-Healthcare/elixir-hl7/issues) if something appears to be handled incorrectly.

## Powerful query tools  

The `HL7.Query` module can be used to perform complex queries and modifications on HL7 messages. These functions have been
designed to offer set-based operations with a pipeline-friendly API, modeled heavily on the patterns used by 
libraries such as jQuery and D3.

## Benchmarks

Use `mix run benchmark.exs` to test parsing speeds on your local system.
The results should be somewhere in the thousands per second range for most modern laptops.

## Examples

Sample messages from Wikipedia and the NIST have been included in the `HL7.Examples` module for testing and learning purposes.

## Route

HL7 messages can be minimally validated to gather header (MSH segment) information for quick routing and acknowledgements.

    iex> hl7_text = HL7.Examples.wikipedia_sample_hl7()
    ...> raw_msg = HL7.Message.raw(hl7_text)
    ...> raw_msg.header.message_type
    "ADT" 

See the `HL7.RawMessage` and `HL7.Header` modules for more details.

## Parse

HL7 messages can be fully parsed into lists of lists, accessible via a `segments` property on the resulting structs. 

    iex> hl7_text = HL7.Examples.wikipedia_sample_hl7()
    ...> parsed_msg = HL7.Message.new(hl7_text)
    ...> parsed_msg |> HL7.Message.get_segment_parts([0])
    ["MSH", "EVN", "PID", "PV1", "OBX", "OBX", "AL1", "DG1"]
    
    iex> hl7_text = HL7.Examples.nist_syndromic_hl7()
    ...> parsed_msg = HL7.Message.new(hl7_text)
    ...> parsed_msg |> HL7.Message.get_value(["OBX", 5, 0, 1])
    "Emergency Care"
        
The `HL7.Message` module contains relatively low-level functions to parse, inspect and modify messages.

## Query

Advanced manipulation and analysis of HL7 messages can be performed with the `HL7.Query` module. 

It supports a pipeline-friendly API modeled after jQuery and D3, allowing set-based document operations and queries.

Messages can be broken into nested segment groups using Segment Grammar Notation. Individual segments can be
decomposed using a somewhat standard Field Notation.  

## Create

HL7 messages can be constructed from scratch with the `HL7.Message` module. Passing an `HL7.Header` struct to
`HL7.Message.new/1` will produce a base message to which you can add additional segments. These can be appended as list data. 

The final raw message can be produced by invoking the `to_string/1` protocol on either the `HL7.Query` or `HL7.Message` structs.

## HL7 from disk

The `HL7` module contains utility methods to open file streams of HL7 message content stored as either MLLP or SMAT. 
Other formats are supported by specifying expected prefix and suffix delimiters between messages.

## HL7 over sockets

A separate library, Elixir-MLLP, exists to manage MLLP connections containing HL7 messages. 

## Getting started

Add this library to your mix.exs file:

```elixir
defp deps do
  [{:elixir_hl7, "~> 0.3.0"}]
end
```

The `HL7.Examples` module provides sample data that you can use to explore the API. 

```
iex> raw_hl7 = HL7.Examples.wikipedia_sample_hl7
"MSH|^~&|MegaReg|XYZHospC|SuperOE|XYZImgCtr|20060529090131-0500||ADT^A01^ADT_A01|01052901|P|2.5\rEVN||200605290901||||200605290900\rPID|||56782445^^^UAReg^PI||KLEINSAMPLE^BARRY^Q^JR||19620910|M||2028-9^^HL70005^RA99113^^XYZ|260 GOODWIN CREST DRIVE^^BIRMINGHAM^AL^35209^^M~NICKELL’S PICKLES^10000 W 100TH AVE^BIRMINGHAM^AL^35200^^O|||||||0105I30001^^^99DEF^AN\rPV1||I|W^389^1^UABH^^^^3||||12345^MORGAN^REX^J^^^MD^0010^UAMC^L||67890^GRAINGER^LUCY^X^^^MD^0010^UAMC^L|MED|||||A0||13579^POTTER^SHERMAN^T^^^MD^0010^UAMC^L|||||||||||||||||||||||||||200605290900\rOBX|1|NM|^Body Height||1.80|m^Meter^ISO+|||||F\rOBX|2|NM|^Body Weight||79|kg^Kilogram^ISO+|||||F\rAL1|1||^ASPIRIN\rDG1|1||786.50^CHEST PAIN, UNSPECIFIED^I9|||A\r"

```

To extract only the MSH header information from a message, generate an `HL7.RawMessage` using:

```
iex> raw_msg = raw_hl7 |> HL7.Message.raw() 
```

You could also take that sample message and generate a fully parsed `HL7.Message` like so:

```
iex> msg = raw_hl7 |> HL7.Message.new() 
```

Using the `HL7.Query` module, you can select and even sub-select segments or segment groups within a message and 
then replace the contents:

```
iex> import HL7.Query
iex> msg = HL7.Examples.nist_immunization_hl7() |> HL7.Message.new()
iex> msg |> select() |> get_part("PID-5")
iex> msg |> select() |> get_parts("RXR-2.2")
iex> msg |> select("OBX") |> delete() |> to_message() |> to_string()
iex> msg |> select("ORC RXA {RXR} {[OBX]}") |> select("OBX") |> replace_parts("3.2", fn q -> "TEST: " <> q.part end) 
```

## Status

This project is approaching a v1.0 release. The API is mostly stable at this point. 

Also, please be aware of the details of the license (Apache 2.0). 


# License

Elixir-HL7 source code is released under Apache 2 License. Check LICENSE file for more information.
