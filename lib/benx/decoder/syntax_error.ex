defmodule Benx.Decoder.SyntaxError do
  @moduledoc """
  Raised when parsing a binary that isn't valid according to BEP-3.
  """

  defexception [:message, :position]

  def exception(opts) do
    position = opts[:position]
    message = opts[:message]

    %__MODULE__{message: message, position: position}
  end
end
