# Elixir HL7 
An Elixir library for working with HL7 v2.x healthcare data 

Elixir-HL7 provides functions to parse, query and modify healthcare data that conforms to the HL7 v2.x standards. Elixir-HL7 also provides basic support for reading HL7 file streams with configurable delimiters (MLLP and SMAT included). 

You can learn more about HL7 here:
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7) 

## Status

This project is at v0.x for a reason. The API and internals will likely change quite a bit between now and v1.0. Also, be aware of the details of the license (Apache 2.0). 

## Design goals

- Relatively fast HL7 parsing
- Flexible jQuery/D3-style message queries and manipulation
- Support for common industry methods and nomenclature (segment grammar notation, etc.)

### Speed

For basic reads we are aiming at tens of thousands of messages per second on a typical developer laptop.
We will include more meaningful benchmarks soon.

### Non-strict evaluation and flexibility

HL7 messages can be minimally validated to gather header (MSH segment) information for quick routing and acknowledgements using `HL7.Message.raw(text)` to create an `HL7.RawMessage` struct.

Messages can be fully parsed into lists of lists using `HL7.Message.new(text)` to generate a complete `HL7.Message` struct.

Segment names and specific message schemas are not enforced. Optional HL7 delimiters specified in the MSH segment are respected when parsing.

### Lossless data round-trips

[raw hl7 string] <-> [lists of lists] 

## Getting started

The `HL7.Examples` module provides sample data that you can use to explore the API. 

```
iex> raw_hl7 = HL7.Examples.wikipedia_sample_hl7

"MSH|^~&|MegaReg|XYZHospC|SuperOE|XYZImgCtr|20060529090131-0500||ADT^A01^ADT_A01|01052901|P|2.5\rEVN||200605290901||||200605290900\rPID|||56782445^^^UAReg^PI||KLEINSAMPLE^BARRY^Q^JR||19620910|M||2028-9^^HL70005^RA99113^^XYZ|260 GOODWIN CREST DRIVE^^BIRMINGHAM^AL^35209^^M~NICKELL’S PICKLES^10000 W 100TH AVE^BIRMINGHAM^AL^35200^^O|||||||0105I30001^^^99DEF^AN\rPV1||I|W^389^1^UABH^^^^3||||12345^MORGAN^REX^J^^^MD^0010^UAMC^L||67890^GRAINGER^LUCY^X^^^MD^0010^UAMC^L|MED|||||A0||13579^POTTER^SHERMAN^T^^^MD^0010^UAMC^L|||||||||||||||||||||||||||200605290900\rOBX|1|NM|^Body Height||1.80|m^Meter^ISO+|||||F\rOBX|2|NM|^Body Weight||79|kg^Kilogram^ISO+|||||F\rAL1|1||^ASPIRIN\rDG1|1||786.50^CHEST PAIN, UNSPECIFIED^I9|||A\r"
```

We can take that sample message and create an `HL7.Message` like so

```
iex> msg = raw_hl7 |> HL7.Message.new() 
```

Using the `HL7.Query` module, you can select and even sub-select segments or segment groups within a message and then replace the contents.

(Doc Tests and extended examples coming soon...)

```
iex> import HL7.Query
iex> msg = HL7.Examples.nist_immunization_hl7() |> HL7.Message.new()
iex> msg |> select() |> get_part("PID-5")
iex> msg |> select() |> get_parts("RXR-2.2")
iex> msg |> select("OBX") |> delete() |> to_message() |> to_string()
iex> msg |> select("ORC RXA {RXR} {[OBX]}") |> select("OBX") |> replace_parts("3.2", fn _q, v -> "TEST: " <> v end) 
```

# Roadmap 
- [ ] Module docs and function docs
- [ ] Once it's a bit less wobbly, publish to hex.pm
- [ ] API for constructing HL7 messages from scratch

# License

Elixir-HL7 source code is released under Apache 2 License. Check LICENSE file for more information.
