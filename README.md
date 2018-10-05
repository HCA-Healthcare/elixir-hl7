# elixir-hl7
An Elixir library for working with HL7 v2.x healthcare data 

Elixir-HL7 provides parsers and data-structures for working with healthcare data that conforms to the HL7 v2.x standards. Elixir-HL7 includes data structures for every HL7 Segment and Datatype defined in HL7 versions 2.1, 2.2, 2.3, 2.3.1, 2.4, 2.5, and 2.5.1. Elixir-HL7 also provides basic support for handling MLLP streams. 

You can learn more about HL7 here:
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7) 

## Status

This project is at v0.0.1 for a reason. The API and internals will likely change quite a bit between now and v1.0. Also, be aware of the details of the license (Apache 2.0). 

## Design goals

### Completeness

The library should contain every segment and datatype defined in the HL7 standard 
for each supported HL7 version. We used the XSD files found at [hl7.org](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=214) to build our initial set. 

### Speed

For basic reads we are aiming at tens of thousands of messages per second on a typical developer laptop.
We will include more meaningful benchmarks soon.

### Non-strict evaluation

Non-standard, company-specific data is commonly stored in segments beginning with the letter "Z" such as ZPM (commonly referred to as "Z segments"). Elixir-HL7 stores Z-Segment data as lists of lists in ZSegment structs.

Data for other unknown segments is stored similarly to Z-Segments but in UnknownSegment structs.

Data that overflows the list of fields defined in the specs for segments and datatypes are preserved.

### Flexibility

Access data by ordinal positions or nested lists with named structures 

### Lossless data round-trips

[raw hl7 string] <-> [lists of lists] <-> [data structures]

## Getting started

The HL7.Example module provides sample data you can use to explore the API. 

```
iex> raw_hl7 = HL7.Examples.wikipedia_sample_hl7

"MSH|^~&|MegaReg|XYZHospC|SuperOE|XYZImgCtr|20060529090131-0500||ADT^A01^ADT_A01|01052901|P|2.5\rEVN||200605290901||||200605290900\rPID|||56782445^^^UAReg^PI||KLEINSAMPLE^BARRY^Q^JR||19620910|M||2028-9^^HL70005^RA99113^^XYZ|260 GOODWIN CREST DRIVE^^BIRMINGHAM^AL^35209^^M~NICKELL’S PICKLES^10000 W 100TH AVE^BIRMINGHAM^AL^35200^^O|||||||0105I30001^^^99DEF^AN\rPV1||I|W^389^1^UABH^^^^3||||12345^MORGAN^REX^J^^^MD^0010^UAMC^L||67890^GRAINGER^LUCY^X^^^MD^0010^UAMC^L|MED|||||A0||13579^POTTER^SHERMAN^T^^^MD^0010^UAMC^L|||||||||||||||||||||||||||200605290900\rOBX|1|NM|^Body Height||1.80|m^Meter^ISO+|||||F\rOBX|2|NM|^Body Weight||79|kg^Kilogram^ISO+|||||F\rAL1|1||^ASPIRIN\rDG1|1||786.50^CHEST PAIN, UNSPECIFIED^I9|||A\r"
```

We can take that sample message and create an `HL7.Message` like so

```
iex> raw_hl7 |> HL7.Message.new() |> HL7.Message.make_structs()
```

# Roadmap 
- [ ] Module docs and function docs
- [ ] Support adding custom Z-Segments
- [ ] Once it's a bit less wobbly, publish to hex.pm
- [ ] Property-based tests and StreamData generators for HL7 segments and datatypes
- [ ] Support for higher HL7 versions (e.g. 2.8)

# License

Elixir-HL7 source code is released under Apache 2 License. Check LICENSE file for more information.