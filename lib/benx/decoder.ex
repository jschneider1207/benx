defmodule Benx.Decoder do
  @moduledoc """
  Provides decoding for iodata according to the
  Bencoding specification.
  """
  alias Benx.Decoder.SyntaxError

  @doc """
  Decodes a Bencoded iolist.
  """
  @spec decode(iodata) ::
    {:ok, Benx.Encoder.t} |
    {:error, String.t, integer}
  def decode(data) do
    with flattened = :lists.flatten(data),
         {:ok, term, [], _pos} <- do_decode(flattened)
    do
      {:ok, term}
    else
      {:ok, _term, _rest, pos} ->
        {:error, "unable to determine type", pos}
      err ->
        err
    end
  end

  @doc """
  Decodes a Bencoded iolist. Raises on syntax errors.
  """
  @spec decode!(iodata) :: String.t
  def decode!(data) do
    case decode(data) do
      {:ok, term} -> term
      {:error, reason, pos} -> raise SyntaxError, message: reason, position: pos
    end
  end

  defp do_decode(data, pos \\ 0)
  defp do_decode([?i|rem], pos) do
    decode_integer(rem, pos + 1)
  end
  defp do_decode([?l|rem], pos) do
    decode_list(rem, pos + 1)
  end
  defp do_decode([?d|rem], pos) do
    decode_map(rem, pos + 1)
  end
  defp do_decode(data, pos) do
    decode_string_length(data, pos)
  end

  defp decode_integer(data, pos, acc \\ [])
  defp decode_integer([?-|[?0|[?e|_rest]]], pos, _acc) do
    {:error, "-0 is an invalid integer", pos}
  end
  defp decode_integer([?e|rest], pos, acc) do
    integer =
      acc
      |> :lists.reverse()
      |> :erlang.list_to_integer()
    {:ok, integer, rest, pos + 1}
  end
  defp decode_integer([digit|rem], pos, acc) do
    decode_integer(rem, pos + 1, [digit|acc])
  end

  defp decode_list(data, pos, acc \\ [])
  defp decode_list([?e|rest], pos, acc) do
    {:ok, :lists.reverse(acc), rest, pos + 1}
  end
  defp decode_list([?i|rem], pos, acc) do
    with {:ok, integer, rest, new_pos} <- decode_integer(rem, pos + 1),
         do: decode_list(rest, new_pos, [integer|acc])
  end
  defp decode_list([?l|rem], pos, acc) do
    with {:ok, list, rest, new_pos} <- decode_list(rem, pos + 1),
         do: decode_list(rest, new_pos, [list|acc])
  end
  defp decode_list([?d|rem], pos, acc) do
    with {:ok, map, rest, new_pos} <- decode_map(rem, pos + 1),
         do: decode_list(rest, new_pos, [map|acc])
  end
  defp decode_list([], pos, _acc) do
    {:error, "expected 'e' for end of list or for list to continue", pos}
  end
  defp decode_list(data, pos, acc) do
    with {:ok, string, rest, new_pos} <- decode_string_length(data, pos),
         do: decode_list(rest, new_pos, [string|acc])
  end

  defp decode_map(data, pos, acc \\ %{})
  defp decode_map([?e|rest], pos, acc) do
    {:ok, acc, rest, pos + 1}
  end
  defp decode_map([], pos, _acc) do
    {:error, "expected 'e' for end of dict or for dict to continue", pos}
  end
  defp decode_map(data, pos, acc) do
    with {:ok, key, rest, new_pos} <- decode_string_length(data, pos),
         {:ok, value, rest, new_pos} <- do_decode(rest, new_pos),
         do: decode_map(rest, new_pos, Map.put(acc, key, value))
  end

  defp decode_string_length(data, pos, acc \\ [])
  defp decode_string_length([?:|_rem], pos, []) do
    {:error, "expected string length", pos}
  end
  defp decode_string_length([?:|rem], pos, acc) do
    length =
      acc
      |> :lists.reverse()
      |> :erlang.list_to_integer()
      decode_string(rem, length, pos + 1)
  end
  defp decode_string_length([], pos, acc) do
    start_pos = pos - length(acc)
    {:error, "unable to determine type", start_pos}
  end
  defp decode_string_length([digit|rem], pos, acc) do
    decode_string_length(rem, pos + 1, [digit|acc])
  end

  defp decode_string(data, length, pos, acc \\ [])
  defp decode_string(rest, 0, pos, acc) do
    string =
      acc
      |> :lists.reverse()
      |> :erlang.iolist_to_binary()
    {:ok, string, rest, pos}
  end
  defp decode_string([], length, pos, acc) do
    start_pos = pos - length(acc)
    {:error, "expected #{length} more character(s) for string", start_pos}
  end
  defp decode_string([char|rem], length, pos, acc) do
    decode_string(rem, length - 1, pos + 1, [char|acc])
  end
end
