defmodule Benx do
  @moduledoc """
  Provides shortcuts to Bencoding encode/decode functions.
  """

  @doc """
  Alias for `Benx.Encoder.encode/1`.
  """
  defdelegate encode(term), to: Benx.Encoder

  @doc """
  Alias for `Benx.Decoder.decode/1`.
  """
  defdelegate decode(data), to: Benx.Decoder

  @doc """
  Alias for `Benx.Decoder.decode!/1`.
  """
  defdelegate decode!(data), to: Benx.Decoder
end
