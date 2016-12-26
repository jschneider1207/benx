defprotocol Benx.Encoder do
  @moduledoc """
  Provides encoding according to the Bencoding specification for
  strings, atoms, integers, lists, maps, ranges, and streams.
  """

  @typedoc """
  Terms that can be encoded.
  """
  @type t ::
    String.t |
    atom |
    integer |
    [t] |
    %{required(String.t | atom) => t} |
    Range.t |
    Stream.t

  @doc """
  Encodes a term using Bencoding.
  """
  @spec encode(t) :: iodata
  def encode(term)
end

defimpl Benx.Encoder, for: Integer do
  def encode(term) do
    [?i, to_charlist(term), ?e]
  end
end

defimpl Benx.Encoder, for: BitString do
  def encode(term) do
    charlist = to_charlist(term)
    length =
      charlist
      |> length()
      |> to_charlist()
    [length, ?:, charlist]
  end
end

defimpl Benx.Encoder, for: Atom do
  def encode(term) do
    charlist = to_charlist(term)
    length =
      charlist
      |> length()
      |> to_charlist()
    [length, ?:, charlist]
  end
end

defimpl Benx.Encoder, for: List do
  def encode(term) do
    do_encode(term)
  end

  defp do_encode(terms, acc \\ [?l])
  defp do_encode([], acc) do
    :lists.reverse([?e|acc])
  end
  defp do_encode([term|rem], acc) do
    do_encode(rem, [Benx.Encoder.encode(term)|acc])
  end
end

defimpl Benx.Encoder, for: [Range, Stream] do
  def encode(term) do
    term
    |> Enum.to_list()
    |> Benx.Encoder.encode()
  end
end

defimpl Benx.Encoder, for: Map do
  alias Benx.Encoder
  def encode(term) do
    term
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> do_encode()
  end

  defp do_encode(terms, acc \\ [?d])
  defp do_encode([], acc) do
    :lists.reverse([?e|acc])
  end
  defp do_encode([{key, value}|rem], acc) when is_atom(key) or is_bitstring(key) do
    ekey = Encoder.encode(key)
    evalue = Encoder.encode(value)
    do_encode(rem, [evalue|[ekey|acc]])
  end
end
