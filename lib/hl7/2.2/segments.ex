defmodule Hl7.V2_2.Segments.ZSegment do
  @moduledoc """
  HL7 segment data structure for handling non-standard Z-Segments
  """
  use Hl7.Segment, fields: [segment: nil, values: nil], undefined_struct: true
end

defmodule Hl7.V2_2.Segments.UnknownSegment do
  @moduledoc """
  HL7 segment data structure for handling unknown segment types
  """
  use Hl7.Segment, fields: [segment: nil, values: nil], undefined_struct: true
end

defmodule Hl7.V2_2.Segments do
  alias Hl7.V2_2.Segments

  def parse(nested_lists), do: parse(nested_lists |> unlist, nested_lists)
  def parse("ACC", nested_lists), do: Segments.ACC.new(nested_lists)
  def parse("ADD", nested_lists), do: Segments.ADD.new(nested_lists)
  def parse("AL1", nested_lists), do: Segments.AL1.new(nested_lists)
  def parse("BHS", nested_lists), do: Segments.BHS.new(nested_lists)
  def parse("BLG", nested_lists), do: Segments.BLG.new(nested_lists)
  def parse("BTS", nested_lists), do: Segments.BTS.new(nested_lists)
  def parse("DG1", nested_lists), do: Segments.DG1.new(nested_lists)
  def parse("DSC", nested_lists), do: Segments.DSC.new(nested_lists)
  def parse("DSP", nested_lists), do: Segments.DSP.new(nested_lists)
  def parse("ERR", nested_lists), do: Segments.ERR.new(nested_lists)
  def parse("EVN", nested_lists), do: Segments.EVN.new(nested_lists)
  def parse("FHS", nested_lists), do: Segments.FHS.new(nested_lists)
  def parse("FT1", nested_lists), do: Segments.FT1.new(nested_lists)
  def parse("FTS", nested_lists), do: Segments.FTS.new(nested_lists)
  def parse("GT1", nested_lists), do: Segments.GT1.new(nested_lists)
  def parse("IN1", nested_lists), do: Segments.IN1.new(nested_lists)
  def parse("IN2", nested_lists), do: Segments.IN2.new(nested_lists)
  def parse("IN3", nested_lists), do: Segments.IN3.new(nested_lists)
  def parse("MFA", nested_lists), do: Segments.MFA.new(nested_lists)
  def parse("MFE", nested_lists), do: Segments.MFE.new(nested_lists)
  def parse("MFI", nested_lists), do: Segments.MFI.new(nested_lists)
  def parse("MRG", nested_lists), do: Segments.MRG.new(nested_lists)
  def parse("MSA", nested_lists), do: Segments.MSA.new(nested_lists)
  def parse("MSH", nested_lists), do: Segments.MSH.new(nested_lists)
  def parse("NCK", nested_lists), do: Segments.NCK.new(nested_lists)
  def parse("NK1", nested_lists), do: Segments.NK1.new(nested_lists)
  def parse("NPU", nested_lists), do: Segments.NPU.new(nested_lists)
  def parse("NSC", nested_lists), do: Segments.NSC.new(nested_lists)
  def parse("NST", nested_lists), do: Segments.NST.new(nested_lists)
  def parse("NTE", nested_lists), do: Segments.NTE.new(nested_lists)
  def parse("OBR", nested_lists), do: Segments.OBR.new(nested_lists)
  def parse("OBX", nested_lists), do: Segments.OBX.new(nested_lists)
  def parse("ODS", nested_lists), do: Segments.ODS.new(nested_lists)
  def parse("ODT", nested_lists), do: Segments.ODT.new(nested_lists)
  def parse("OM1", nested_lists), do: Segments.OM1.new(nested_lists)
  def parse("OM2", nested_lists), do: Segments.OM2.new(nested_lists)
  def parse("OM3", nested_lists), do: Segments.OM3.new(nested_lists)
  def parse("OM4", nested_lists), do: Segments.OM4.new(nested_lists)
  def parse("OM5", nested_lists), do: Segments.OM5.new(nested_lists)
  def parse("OM6", nested_lists), do: Segments.OM6.new(nested_lists)
  def parse("ORC", nested_lists), do: Segments.ORC.new(nested_lists)
  def parse("PID", nested_lists), do: Segments.PID.new(nested_lists)
  def parse("PR1", nested_lists), do: Segments.PR1.new(nested_lists)
  def parse("PRA", nested_lists), do: Segments.PRA.new(nested_lists)
  def parse("PV1", nested_lists), do: Segments.PV1.new(nested_lists)
  def parse("PV2", nested_lists), do: Segments.PV2.new(nested_lists)
  def parse("QRD", nested_lists), do: Segments.QRD.new(nested_lists)
  def parse("QRF", nested_lists), do: Segments.QRF.new(nested_lists)
  def parse("RQ1", nested_lists), do: Segments.RQ1.new(nested_lists)
  def parse("RQD", nested_lists), do: Segments.RQD.new(nested_lists)
  def parse("RXA", nested_lists), do: Segments.RXA.new(nested_lists)
  def parse("RXC", nested_lists), do: Segments.RXC.new(nested_lists)
  def parse("RXD", nested_lists), do: Segments.RXD.new(nested_lists)
  def parse("RXE", nested_lists), do: Segments.RXE.new(nested_lists)
  def parse("RXG", nested_lists), do: Segments.RXG.new(nested_lists)
  def parse("RXO", nested_lists), do: Segments.RXO.new(nested_lists)
  def parse("RXR", nested_lists), do: Segments.RXR.new(nested_lists)
  def parse("STF", nested_lists), do: Segments.STF.new(nested_lists)
  def parse("UB1", nested_lists), do: Segments.UB1.new(nested_lists)
  def parse("UB2", nested_lists), do: Segments.UB2.new(nested_lists)
  def parse("URD", nested_lists), do: Segments.URD.new(nested_lists)
  def parse("URS", nested_lists), do: Segments.URS.new(nested_lists)
  def parse(<<"Z", _::binary>>, nested_lists), do: Segments.ZSegment.new(nested_lists)
  def parse(_, nested_lists), do: Segments.UnknownSegment.new(nested_lists)

  def unlist([h | _]) do
    unlist(h)
  end

  def unlist(v) do
    v
  end
end
