defmodule Benx.DecoderTest do
  use ExUnit.Case, async: :true
  alias Benx.Decoder

  test "decode positive integer" do
    assert Decoder.decode!('i42e') === 42
  end

  test "decode negative integer" do
    assert Decoder.decode!('i-42e') === -42
  end

  test "decode zero" do
    assert Decoder.decode!('i0e') === 0
  end

  test "negative 0 syntax error" do
    assert match?({:error, _reason, _pos}, Decoder.decode('i-0e'))
  end

  test "decode string" do
    assert Decoder.decode!('3:abc') === "abc"
  end

  test "decode binary" do
    assert Decoder.decode!([?3, ?:, 0, 1, 2]) === <<0, 1, 2>>
  end

  test "decode empty string" do
    assert Decoder.decode!('0:') === ""
  end

  test "string length mismatch syntax error" do
    assert match?({:error, _reason, _pos}, Decoder.decode('4:map'))
  end

  test "decode empty list" do
    assert Decoder.decode!('le') === []
  end

  test "decode list" do
    assert Decoder.decode!('li1e1:ali2ei3eee') === [1, "a", [2, 3]]
  end

  test "non-ending list syntax error" do
    assert match?({:error, _reason, _pos}, Decoder.decode('li1e'))
  end

  test "decode empty map" do
    assert Decoder.decode!('de') === %{}
  end

  test "decode map" do
    assert Decoder.decode!('d1:ai1e1:bli2ei3ee1:cd1:d1:eee') ===
      %{"a" => 1, "b" => [2, 3], "c" => %{"d" => "e"}}
  end

  test "non-ending map syntax error" do
    assert match?({:error, _reason, _pos}, Decoder.decode('d3:mapi1e'))
  end

  test "non-string map key syntax error" do
    assert match?({:error, _reason, _pos}, Decoder.decode('di1e'))
  end
end
