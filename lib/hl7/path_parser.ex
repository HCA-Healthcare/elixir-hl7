# Generated from parsec_source/path_parser.ex.exs, do not edit.
# Generated at 2024-04-25 17:44:16Z.

defmodule HL7.PathParser do
  @doc """
  Parses the given `binary` as parse.

  Returns `{:ok, [token], rest, context, position, byte_offset}` or
  `{:error, reason, rest, context, line, byte_offset}` where `position`
  describes the location of the parse (start position) as `{line, offset_to_start_of_line}`.

  To column where the error occurred can be inferred from `byte_offset - offset_to_start_of_line`.

  ## Options

    * `:byte_offset` - the byte offset for the whole binary, defaults to 0
    * `:line` - the line and the byte offset into that line, defaults to `{1, byte_offset}`
    * `:context` - the initial context value. It will be converted to a map

  """
  @spec parse(binary, keyword) ::
          {:ok, [term], rest, context, line, byte_offset}
          | {:error, reason, rest, context, line, byte_offset}
        when line: {pos_integer, byte_offset},
             byte_offset: pos_integer,
             rest: binary,
             reason: String.t(),
             context: map
  def parse(binary, opts \\ []) when is_binary(binary) do
    context = Map.new(Keyword.get(opts, :context, []))
    byte_offset = Keyword.get(opts, :byte_offset, 0)

    line =
      case Keyword.get(opts, :line, 1) do
        {_, _} = line -> line
        line -> {line, byte_offset}
      end

    case parse__0(binary, [], [], context, line, byte_offset) do
      {:ok, acc, rest, context, line, offset} ->
        {:ok, :lists.reverse(acc), rest, context, line, offset}

      {:error, _, _, _, _, _} = error ->
        error
    end
  end

  defp parse__0(rest, acc, stack, context, line, offset) do
    parse__4(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__2(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__3(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__2(rest, [], stack, context, line, offset)
  end

  defp parse__4(rest, acc, stack, context, line, offset) do
    parse__5(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__5(rest, acc, stack, context, line, offset) do
    parse__6(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__6(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 65 and x0 <= 90 do
    parse__7(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__6(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse__3(rest, acc, stack, context, line, offset)
  end

  defp parse__7(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__8(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__7(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 65 and x0 <= 90 do
    parse__8(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__7(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse__3(rest, acc, stack, context, line, offset)
  end

  defp parse__8(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__9(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__8(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 65 and x0 <= 90 do
    parse__9(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__8(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse__3(rest, acc, stack, context, line, offset)
  end

  defp parse__9(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__10(
      rest,
      [Enum.join(:lists.reverse(user_acc), "")] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__10(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse__11(rest, [segment: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse__11(rest, acc, stack, context, line, offset) do
    parse__12(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__12(rest, acc, stack, context, line, offset) do
    parse__16(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__14(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__13(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__15(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__14(rest, [], stack, context, line, offset)
  end

  defp parse__16(<<"[", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__17(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__16(rest, acc, stack, context, line, offset) do
    parse__15(rest, acc, stack, context, line, offset)
  end

  defp parse__17(rest, acc, stack, context, line, offset) do
    parse__22(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__19(<<"*", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__20(rest, ["*"] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__19(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse__15(rest, acc, stack, context, line, offset)
  end

  defp parse__20(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__18(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__21(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__19(rest, [], stack, context, line, offset)
  end

  defp parse__22(rest, acc, stack, context, line, offset) do
    parse__23(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__23(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__24(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__23(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse__21(rest, acc, stack, context, line, offset)
  end

  defp parse__24(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__26(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__24(rest, acc, stack, context, line, offset) do
    parse__25(rest, acc, stack, context, line, offset)
  end

  defp parse__26(rest, acc, stack, context, line, offset) do
    parse__24(rest, acc, stack, context, line, offset)
  end

  defp parse__25(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__27(
      rest,
      (
        [head | tail] = :lists.reverse(user_acc)
        [:lists.foldl(fn x, acc -> x - 48 + acc * 10 end, head, tail)]
      ) ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__27(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__18(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__18(<<"]", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__28(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__18(rest, acc, stack, context, line, offset) do
    parse__15(rest, acc, stack, context, line, offset)
  end

  defp parse__28(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__13(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__13(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__29(
      rest,
      [segment_number: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__29(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__1(rest, acc, stack, context, line, offset) do
    parse__33(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__31(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__30(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__32(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__31(rest, [], stack, context, line, offset)
  end

  defp parse__33(rest, acc, stack, context, line, offset) do
    parse__34(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__34(<<"-", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__35(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__34(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__35(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse__35(rest, acc, stack, context, line, offset) do
    parse__40(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__37(<<"*", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__38(rest, ["*"] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__37(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse__32(rest, acc, stack, context, line, offset)
  end

  defp parse__38(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__36(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__39(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__37(rest, [], stack, context, line, offset)
  end

  defp parse__40(rest, acc, stack, context, line, offset) do
    parse__41(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__41(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__42(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__41(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse__39(rest, acc, stack, context, line, offset)
  end

  defp parse__42(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__44(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__42(rest, acc, stack, context, line, offset) do
    parse__43(rest, acc, stack, context, line, offset)
  end

  defp parse__44(rest, acc, stack, context, line, offset) do
    parse__42(rest, acc, stack, context, line, offset)
  end

  defp parse__43(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__45(
      rest,
      (
        [head | tail] = :lists.reverse(user_acc)
        [:lists.foldl(fn x, acc -> x - 48 + acc * 10 end, head, tail)]
      ) ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__45(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__36(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__36(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse__46(rest, [field: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse__46(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__30(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__30(rest, acc, stack, context, line, offset) do
    parse__50(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__48(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__47(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__49(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__48(rest, [], stack, context, line, offset)
  end

  defp parse__50(rest, acc, stack, context, line, offset) do
    parse__51(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__51(rest, acc, stack, context, line, offset) do
    parse__55(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__53(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__52(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__54(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__53(rest, [], stack, context, line, offset)
  end

  defp parse__55(<<"[", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__56(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__55(rest, acc, stack, context, line, offset) do
    parse__54(rest, acc, stack, context, line, offset)
  end

  defp parse__56(rest, acc, stack, context, line, offset) do
    parse__61(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__58(<<"*", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__59(rest, ["*"] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__58(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse__54(rest, acc, stack, context, line, offset)
  end

  defp parse__59(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__57(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__60(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__58(rest, [], stack, context, line, offset)
  end

  defp parse__61(rest, acc, stack, context, line, offset) do
    parse__62(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__62(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__63(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__62(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse__60(rest, acc, stack, context, line, offset)
  end

  defp parse__63(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__65(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__63(rest, acc, stack, context, line, offset) do
    parse__64(rest, acc, stack, context, line, offset)
  end

  defp parse__65(rest, acc, stack, context, line, offset) do
    parse__63(rest, acc, stack, context, line, offset)
  end

  defp parse__64(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__66(
      rest,
      (
        [head | tail] = :lists.reverse(user_acc)
        [:lists.foldl(fn x, acc -> x - 48 + acc * 10 end, head, tail)]
      ) ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__66(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__57(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__57(<<"]", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__67(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__57(rest, acc, stack, context, line, offset) do
    parse__54(rest, acc, stack, context, line, offset)
  end

  defp parse__67(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__52(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__52(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse__68(rest, [repetition: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse__68(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__47(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__47(rest, acc, stack, context, line, offset) do
    parse__72(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__70(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__69(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__71(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__70(rest, [], stack, context, line, offset)
  end

  defp parse__72(<<".", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__73(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__72(rest, acc, stack, context, line, offset) do
    parse__71(rest, acc, stack, context, line, offset)
  end

  defp parse__73(rest, acc, stack, context, line, offset) do
    parse__74(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__74(rest, acc, stack, context, line, offset) do
    parse__79(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__76(<<"*", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__77(rest, ["*"] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__76(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse__71(rest, acc, stack, context, line, offset)
  end

  defp parse__77(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__75(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__78(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__76(rest, [], stack, context, line, offset)
  end

  defp parse__79(rest, acc, stack, context, line, offset) do
    parse__80(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__80(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__81(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__80(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse__78(rest, acc, stack, context, line, offset)
  end

  defp parse__81(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__83(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__81(rest, acc, stack, context, line, offset) do
    parse__82(rest, acc, stack, context, line, offset)
  end

  defp parse__83(rest, acc, stack, context, line, offset) do
    parse__81(rest, acc, stack, context, line, offset)
  end

  defp parse__82(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__84(
      rest,
      (
        [head | tail] = :lists.reverse(user_acc)
        [:lists.foldl(fn x, acc -> x - 48 + acc * 10 end, head, tail)]
      ) ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__84(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__75(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__75(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse__85(rest, [component: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse__85(rest, acc, stack, context, line, offset) do
    parse__89(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__87(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__86(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__88(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__87(rest, [], stack, context, line, offset)
  end

  defp parse__89(<<".", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__90(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__89(rest, acc, stack, context, line, offset) do
    parse__88(rest, acc, stack, context, line, offset)
  end

  defp parse__90(rest, acc, stack, context, line, offset) do
    parse__91(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__91(rest, acc, stack, context, line, offset) do
    parse__96(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse__93(<<"*", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__94(rest, ["*"] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__93(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse__88(rest, acc, stack, context, line, offset)
  end

  defp parse__94(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__92(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__95(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse__93(rest, [], stack, context, line, offset)
  end

  defp parse__96(rest, acc, stack, context, line, offset) do
    parse__97(rest, [], [acc | stack], context, line, offset)
  end

  defp parse__97(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__98(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__97(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse__95(rest, acc, stack, context, line, offset)
  end

  defp parse__98(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse__100(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__98(rest, acc, stack, context, line, offset) do
    parse__99(rest, acc, stack, context, line, offset)
  end

  defp parse__100(rest, acc, stack, context, line, offset) do
    parse__98(rest, acc, stack, context, line, offset)
  end

  defp parse__99(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__101(
      rest,
      (
        [head | tail] = :lists.reverse(user_acc)
        [:lists.foldl(fn x, acc -> x - 48 + acc * 10 end, head, tail)]
      ) ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__101(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__92(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__92(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse__102(
      rest,
      [subcomponent: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse__102(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__86(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__86(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse__69(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse__69(<<"!", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__103(rest, [truncate: [true]] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse__69(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__103(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse__103(<<""::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse__104("", [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse__103(rest, _acc, _stack, context, line, offset) do
    {:error, "expected end of string", rest, context, line, offset}
  end

  defp parse__104(rest, acc, _stack, context, line, offset) do
    {:ok, acc, rest, context, line, offset}
  end
end
