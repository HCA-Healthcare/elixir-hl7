# Elixir HL7 
[![hex.pm version](https://img.shields.io/hexpm/v/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7) 
[![hex.pm downloads](https://img.shields.io/hexpm/dt/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)
[![hex.pm license](https://img.shields.io/hexpm/l/elixir_hl7.svg)](https://hex.pm/packages/elixir_hl7)

> ### Note {: .warning}
>
>
> We are building a simpler and more Elixir-friendly API for this library, centered on
> the `HL7` and `HL7.Path` modules. 
> 
> The new API will lead to the deprecation of `HL7.Query` and related code. 
> 
> These will likely not be removed for some time, and their
> removal will coincide with a major version release. For now, the two systems can exchange data when needed.

An Elixir library for working with HL7 v2.x healthcare data 

Elixir HL7 provides functions to parse, query and modify healthcare data that conforms to the HL7 v2.x standards. 
It should be able to reconstruct any HL7 Message without data loss or corruption.

It also provides basic support for reading HL7 file streams with configurable delimiters (MLLP included). 

This library has been tested on a fairly wide variety of real-world HL7 messages to ensure correctness and flexibility. 

You can learn more about HL7 here:
* The official HL7 website ([hl7.org](http://www.hl7.org/index.cfm))
* Wikipedia's [HL7 article](https://en.wikipedia.org/wiki/Health_Level_7) 

Please [report an issue](https://github.com/HCA-Healthcare/elixir-hl7/issues) if something appears to be handled incorrectly.

## Getting started

Add this library to your mix.exs file:

```elixir
defp deps do
  [{:elixir_hl7, "~> 0.9.2"}]
end
```

## Use the Tabs Below to View Instructions

<!-- tabs-open -->

### Examples 

The `HL7.Examples` module contains functions with sample data that you can use in unit tests or to explore the API,

    iex> hl7_text = HL7.Examples.wikipedia_sample_hl7()
    ...> to_string()
    ...> Enum.take(30)
    "ADT" 

### Route

HL7 messages can be minimally validated to gather header (MSH segment) information for quick routing and acknowledgements.

    iex> hl7_text = HL7.Examples.wikipedia_sample_hl7()
    ...> raw_msg = HL7.Message.raw(hl7_text)
    ...> raw_msg.header.message_type
    "ADT" 

See the `HL7.RawMessage` and `HL7.Header` modules for more information.

### Parse

HL7 messages can be fully parsed into lists of lists and strings to provide a compact representation of the message structure.

One could grab the 2nd segment in a message:

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.Message.to_list()
    ...> |> Enum.at(1)
    ["EVN", "", "200605290901", "", "", "", "200605290900"]

Or get the field value of RXA-5.2 (finding the first RXA segment's 5th field, 1st repetition, 2nd component):

    iex> HL7.Examples.nist_immunization_hl7()
    ...> |> HL7.Message.find("RXA")
    ...> |> HL7.Segment.get_part(5, 1, 2)
    "Influenza"
   
It's also possible to modify the data within a segment (but it is much easier to manipulate messages using the `HL7.Query` module):

    iex> HL7.Examples.wikipedia_sample_hl7()
    ...> |> HL7.Message.find("EVN")
    ...> |> HL7.Segment.replace_part("extra data", 5, 2, 1)
    [      
      "EVN",
      "",
      "200605290901",
      "",
      "",
      ["", "", ["", "extra data"]],
      "200605290900"
    ]
        
See the `HL7.Message` and `HL7.Segment` modules for more information.
        
### Query

Advanced manipulation and analysis of HL7 messages can be performed with the `HL7.Query` module. 

It supports a pipeline-friendly API modeled after jQuery and D3, allowing set-based document operations and queries.

Messages can be broken into groups using a segment selector (similar to a CSS selector string) that denotes optional and repeating segments in potentially nested hierarchies. 

Individual segments can be decomposed using a field selector to reference specific field, repetition, component and subcomponent indices.  

Note that all `HL7.Query` selections implicitly retain the entire message structure such that elements can be selected, modified and then used to reconstruct a new HL7 message.    

The act of selecting something never modifies the content of a message. Applying other methods to a selection, such as delete, filter, append, etc., does modify the actual message content.

For instance, this would select all textual diagnoses (DG1-3.2) associated with a patient visit (PV1):

    iex> import HL7.Query
    iex> HL7.Examples.nist_syndromic_hl7()
    ...> |> select("PV1 [{DG1}]")
    ...> |> select("DG1")
    ...> |> find_all(~p"3.2")
    ["Cryptosporidiosis", "Dehydration", "Diarrhea"]
    
The statement `select("PV1 [{DG1}]")` grabs a list of segment groups containing a PV1 segment and any DG1 segments that might follow it.
Thus, we would select one group containing a PV1 segment and three DG1 segments.    

```elixir
[ 
  [ # 1 group of 4 segments
    ["PV1", "1", "(data truncated to fit)"],
    ["DG1", "1", "", [["0074", "Cryptosporidiosis", "I9CDX"]], "", "", "F"],
    ["DG1", "2", "", [["27651", "Dehydration", "I9CDX"]], "", "", "F"],
    ["DG1", "3", "", [["78791", "Diarrhea", "I9CDX"]], "", "", "F"]
  ]
]
```

Then `select("DG1")` creates three groups of individual DG1 segments by searching within the confines of the prior selection.

```elixir
[  # 3 groups of 1 segment each
  [["DG1", "1", "", [["0074", "Cryptosporidiosis", "I9CDX"]], "", "", "F"]],
  [["DG1", "2", "", [["27651", "Dehydration", "I9CDX"]], "", "", "F"]],
  [["DG1", "3", "", [["78791", "Diarrhea", "I9CDX"]], "", "", "F"]]
]
```

Finally, `find_all(~p"3.2")` will return a flattened list of data containing the 3rd field, 1st repetition (the default), 2nd component for each
 selected segment.
  
```elixir
["Cryptosporidiosis", "Dehydration", "Diarrhea"]
```
    
Alternately, one could select and remove every diagnosis tied to a patient visit and then output a modified HL7 message:

    iex> import HL7.Query
    iex> HL7.Examples.nist_syndromic_hl7()
    ...> |> select("PV1 [{DG1}]")
    ...> |> select("DG1")
    ...> |> delete()
    ...> |> to_string()
    "MSH|^~\\&||LakeMichMC^9879874000^NPI|||201204020040||ADT^A03^ADT_A03|NIST-SS-003.32|P|2.5.1|||||||||PH_SS-NoAck^SS Sender^2.16.840.1.114222.4.10.3^ISO\rEVN||201204020030|||||LakeMichMC^9879874000^NPI\rPID|1||33333^^^^MR||^^^^^^~^^^^^^S|||F||2106-3^^CDCREC|^^^^53217^^^^55089|||||||||||2186-5^^CDCREC\rPV1|1||||||||||||||||||33333_001^^^^VN|||||||||||||||||09||||||||201204012130\rOBX|1|CWE|SS003^^PHINQUESTION||261QE0002X^Emergency Care^NUCC||||||F\rOBX|2|NM|21612-7^^LN||45|a^^UCUM|||||F\rOBX|3|CWE|8661-1^^LN||^^^^^^^^Diarrhea, stomach pain, dehydration||||||F\r"  

The following query extracts each Common Order (ORC) group's OBX segments and outputs a list of each order's associated vaccine types.

    iex> import HL7.Query
    iex> HL7.Examples.nist_immunization_hl7()
    ...> |> select("ORC [RXA] [RXR] {OBX}")
    ...> |> filter(fn q -> find_first(q, ~p"3.2") == "vaccine type" end)
    ...> |> map(fn q -> find_all(q, ~p"5.2") end)
    [
        ["Influenza, unspecified formulation"], 
        ["DTaP", "Polio", "Hep B, unspecified formulation"]
    ]   

   
See the `HL7.Query` module for more information.


    
## Create

HL7 messages can be constructed from scratch with the `HL7.Message` module. Passing an `HL7.Header` struct to
`HL7.Message.new/1` will produce a base message upon which you can add additional segments. These can be appended as list data. 

The final raw message can be produced by invoking the `to_string/1` protocol on either the `HL7.Query` or `HL7.Message` structs.

<!-- tabs-close -->


## Files

The `HL7` module contains utility functions to open file streams of HL7 message content with support for MLLP and standard `:line` storage. 
Other formats are somewhat supported by specifying expected prefix and suffix delimiters between messages.

## Sockets

A separate library, Elixir-MLLP, exists to manage MLLP connections. MLLP is a simple protocol on top of TCP that is commonly used for sending and receiving HL7 messages. 

## Status

This project is approaching a v1.0 release. The API is mostly stable at this point. 

Also, please be aware of the details of the license (Apache 2.0). 

# Roadmap

Extending the `HL7` base namespace to provide a simpler and more powerful API.

# License

Elixir-HL7 source code is released under Apache 2 License. Check the LICENSE file for more information.
