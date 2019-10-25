
## 4.0

Bug Fixes (that could change expectations, thus version bump)

- Messages with certain invalid headers will produce InvalidMessage and InvalidHeader structs instead of crashing.
- Messages that do not specify encoding characters will use the HL7 default.
- Messages that do not include Trigger Events will now act as "correct" HL7 (common in Mirth)