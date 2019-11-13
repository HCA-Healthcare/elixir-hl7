
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