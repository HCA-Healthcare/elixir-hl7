defmodule HL7.Header do
  @moduledoc """
  An HL7 header implementation that can be used to build MSH segments and HL7 messages.
  It is also exposed as metadata after parsing any HL7 message.
  """

  @type t :: %HL7.Header{
          message_type: binary(),
          trigger_event: binary(),
          sending_facility: binary(),
          sending_application: binary(),
          message_date_time: String.t(),
          security: String.t(),
          message_control_id: String.t(),
          processing_id: String.t(),
          separators: HL7.Separators.t(),
          hl7_version: binary()
        }

  defstruct message_type: "",
            trigger_event: "",
            sending_facility: "",
            sending_application: "",
            receiving_facility: "",
            receiving_application: "",
            message_date_time: "",
            security: "",
            message_control_id: "",
            processing_id: "",
            separators: %HL7.Separators{},
            hl7_version: ""

  @spec new(String.t(), String.t(), String.t(), String.t() | list(), String.t()) :: HL7.Header.t()
  def new(message_type, trigger_event, message_control_id, processing_id \\ "P", version \\ "2.1") do
    %HL7.Header{
      hl7_version: version,
      message_type: message_type,
      trigger_event: trigger_event,
      message_control_id: message_control_id,
      processing_id: processing_id,
      message_date_time: get_message_date_time()
    }
  end

  @spec to_msh(HL7.Header.t()) :: list()
  def to_msh(%HL7.Header{} = h) do
    [
      "MSH",
      h.separators.field,
      h.separators.encoding_characters,
      h.sending_application,
      h.sending_facility,
      h.receiving_application,
      h.receiving_facility,
      h.message_date_time,
      h.security,
      get_message_type_field(h),
      h.message_control_id,
      h.processing_id,
      h.hl7_version
    ]
  end

  @spec zero_pad(pos_integer(), pos_integer()) :: String.t()
  defp zero_pad(num, digits_needed) when is_integer(num) and is_integer(digits_needed) do
    string_num = Integer.to_string(num)
    pad_size = digits_needed - String.length(string_num)
    zeros = String.duplicate("0", pad_size)
    zeros <> string_num
  end

  @spec get_message_date_time() :: String.t()
  def get_message_date_time() do
    now = DateTime.utc_now()

    zero_pad(now.year, 4) <>
      zero_pad(now.month, 2) <>
      zero_pad(now.day, 2) <>
      zero_pad(now.hour, 2) <> zero_pad(now.minute, 2) <> zero_pad(now.second, 2) <> "+0000"
  end

  @spec get_message_type_field(HL7.Header.t()) :: [String.t()]
  def get_message_type_field(%HL7.Header{} = h) do
    case h.hl7_version do
      "2.1" -> [h.message_type, h.trigger_event]
      "2.2" -> [h.message_type, h.trigger_event]
      "2.3" -> [h.message_type, h.trigger_event]
      "2.3.1" -> [h.message_type, h.trigger_event]
      _ -> [h.message_type, h.trigger_event, h.message_type <> "_" <> h.trigger_event]
    end
  end
end
