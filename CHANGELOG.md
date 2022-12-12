
## 0.6.5

- Using binary copy while parsing to minimize shared binary references

## 0.6.4

- Performance increase with new tokenizer and hot path for default message delimiters -- up to 6x faster parsing now!

## 0.6.1

Added wildcard selections, such as `HL7.Query.select(message, "OBR*")` to select segment types with all trailing
segments until the lead segment is encountered again. Also includes `!NTE` to match any segment but an NTE segment.

## 0.6.0

Changes -- (looser parsing rules, next version will add warnings field)

- HL7.Message will successfully parse messages without an HL7 Version (== nil)
- HL7.Message now contains a fragments field for invalid segment data (empty list normally)

## 0.5.0

Bug Fixes

- Hl7.Query.get_part was not returning multiple repetitions
- Roadmap: will add an "invalid query" struct similar to invalid message


## 0.4.0

Bug Fixes (that could change expectations, thus version bump)

- Messages with certain invalid headers will produce InvalidMessage and InvalidHeader structs instead of crashing.
- Messages that do not specify encoding characters will use the HL7 default.
- Messages that do not include Trigger Events will now act as "correct" HL7
- Roadmap: will include a warnings list for parsed messages such that systems can decide on an appropriate strictness level.