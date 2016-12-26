defmodule Benx.EncoderTest do
  use ExUnit.Case, async: true
  alias Benx.Encoder

  test "encode positive integer" do
    assert flat_encode(42) === 'i42e'
  end

  test "encode negative integer" do
    assert flat_encode(-42) === 'i-42e'
  end

  test "encode zero" do
    assert flat_encode(0) === 'i0e'
  end

  test "encode string" do
    assert flat_encode("abc") === '3:abc'
  end

  test "encode atom" do
    assert flat_encode(:atom) === '4:atom'
  end

  test "encode binary" do
    assert flat_encode(<<0,1,2>>) === [?3, ?:, 0, 1, 2]
  end

  test "encode empty string" do
    assert flat_encode("") === '0:'
  end

  test "encode empty list" do
    assert flat_encode([]) === 'le'
  end

  test "encode list" do
    assert flat_encode([1, "a", [2, 3]]) === 'li1e1:ali2ei3eee'
  end

  test "encode empty map" do
    assert flat_encode(%{}) === 'de'
  end

  test "encode map" do
    assert flat_encode(%{a: 1, b: [2, 3], c: %{d: :e}}) ===
      'd1:ai1e1:bli2ei3ee1:cd1:d1:eee'
  end

  defp flat_encode(term), do: Encoder.encode(term) |> :lists.flatten()
end
