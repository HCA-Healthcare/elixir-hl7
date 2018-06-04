defprotocol Hl7.ToList do
  @doc "Transforms an HL7 data structure into a list of lists"

  # @fallback_to_any true
  def to_list(data)
end

# defimpl Hl7ToListable, for: Any do
#   def to_list(data), do: []
# end
