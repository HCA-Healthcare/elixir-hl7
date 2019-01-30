defmodule HL7.Separators do
  require Logger

  # default HL7 separators
  # |^~\&

  @type t :: %HL7.Separators{
          field: binary(),
          component: binary(),
          field_repeat: binary(),
          escape_char: binary(),
          subcomponent: binary(),
          encoding_characters: binary(),
          delimiter_check: [binary()]
        }

  defstruct field: "|",
            component: "^",
            field_repeat: "~",
            escape_char: "\\",
            subcomponent: "&",
            encoding_characters: "^~\\&",
            delimiter_check: ["&", "^", "~"]

  @spec new(binary(), binary()) :: HL7.Separators.t()
  def new("|", "^~\\&") do
    %HL7.Separators{}
  end

  def new(
        <<field_separator::binary-size(1)>>,
        <<component::binary-size(1), field_repeat::binary-size(1), escape_char::binary-size(1),
          subcomponent::binary-size(1)>> = encoding_characters
      ) do
    %HL7.Separators{
      field: field_separator,
      component: component,
      field_repeat: field_repeat,
      escape_char: escape_char,
      subcomponent: subcomponent,
      delimiter_check: [subcomponent, component, field_repeat],
      encoding_characters: encoding_characters
    }
  end
end
