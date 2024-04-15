defmodule HL7.Separators do
  require Logger

  @moduledoc """
  Contains HL7 delimiter information (optionally specified by the end system) used to parse or generate HL7 messages.
  """

  # default HL7 separators
  # |^~\&#

  @type t :: %HL7.Separators{
          field: binary(),
          component: binary(),
          field_repeat: binary(),
          escape_char: binary(),
          subcomponent: binary(),
          encoding_characters: binary(),
          delimiter_check: [binary()],
          truncation_char: binary()
        }

  defstruct field: "|",
            component: "^",
            field_repeat: "~",
            escape_char: "\\",
            subcomponent: "&",
            encoding_characters: "^~\\&",
            delimiter_check: ["&", "^", "~"],
            truncation_char: ""

  @spec new(String.t()) :: HL7.Separators.t()
  def new(
        <<"MSH", field_separator::binary-size(1), encoding_characters::binary-size(4),
          truncation_char::binary-size(1), field_separator::binary-size(1),
          _tail::binary>> = _raw_text
      )
      when truncation_char != field_separator do
    new(field_separator, encoding_characters <> truncation_char)
  end

  def new(
        <<"MSH", field_separator::binary-size(1), encoding_characters::binary-size(4),
          field_separator::binary-size(1), _tail::binary>> = _raw_text
      ) do
    new(field_separator, encoding_characters)
  end

  # fallback to defaults if incorrect or missing
  def new(_) do
    %HL7.Separators{}
  end

  @spec new(binary(), binary()) :: HL7.Separators.t()
  def new("|", <<"^~\\&", truncation_char::binary>> = encoding_chars) do
    %HL7.Separators{truncation_char: truncation_char, encoding_characters: encoding_chars}
  end

  def new(
        <<field_separator::binary-size(1)>>,
        <<component::binary-size(1), field_repeat::binary-size(1), escape_char::binary-size(1),
          subcomponent::binary-size(1), truncation_char::binary>> = encoding_characters
      ) do
    %HL7.Separators{
      field: field_separator,
      component: component,
      field_repeat: field_repeat,
      escape_char: escape_char,
      subcomponent: subcomponent,
      delimiter_check: [subcomponent, component, field_repeat],
      encoding_characters: encoding_characters,
      truncation_char: truncation_char
    }
  end

  # fallback to defaults if incorrect or missing
  def new(_, _) do
    %HL7.Separators{}
  end
end
