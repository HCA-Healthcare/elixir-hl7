defmodule HL7.V2_1.Segments.ZSegment do
  @moduledoc """
  HL7 segment data structure for handling non-standard Z-Segments
  """
  use HL7.Segment, fields: [segment: nil, values: nil], undefined_struct: true
end

defmodule HL7.V2_1.Segments.UnknownSegment do
  @moduledoc """
  HL7 segment data structure for handling unknown segment types
  """
  use HL7.Segment, fields: [segment: nil, values: nil], undefined_struct: true
end

defmodule HL7.V2_1.Segments do
  alias HL7.V2_1.Segments

  def parse(nested_lists), do: parse(nested_lists |> unlist, nested_lists)
  def parse("ACC", nested_lists), do: Segments.ACC.new(nested_lists)
  def parse("ADD", nested_lists), do: Segments.ADD.new(nested_lists)
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
  def parse("ORC", nested_lists), do: Segments.ORC.new(nested_lists)
  def parse("ORO", nested_lists), do: Segments.ORO.new(nested_lists)
  def parse("PID", nested_lists), do: Segments.PID.new(nested_lists)
  def parse("PR1", nested_lists), do: Segments.PR1.new(nested_lists)
  def parse("PV1", nested_lists), do: Segments.PV1.new(nested_lists)
  def parse("QRD", nested_lists), do: Segments.QRD.new(nested_lists)
  def parse("QRF", nested_lists), do: Segments.QRF.new(nested_lists)
  def parse("RX1", nested_lists), do: Segments.RX1.new(nested_lists)
  def parse("UB1", nested_lists), do: Segments.UB1.new(nested_lists)
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
