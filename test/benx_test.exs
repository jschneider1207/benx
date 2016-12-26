defmodule BenxTest do
  use ExUnit.Case, async: true

  test "integer sanity check" do
    assert (Benx.encode(1) |> Benx.decode!()) === 1
  end

  test "string sanity check" do
    assert (Benx.encode("abc") |> Benx.decode!()) === "abc"
  end

  test "atom sanity check" do
    assert (Benx.encode(:abc) |> Benx.decode!()) === "abc"
  end

  test "binary sanity check" do
    assert (Benx.encode(<<1, 2, 3>>) |> Benx.decode!()) === <<1, 2, 3>>
  end

  test "list sanity check" do
    assert (Benx.encode([1,"a"]) |> Benx.decode!()) === [1, "a"]
  end

  test "map sanity check" do
    assert (Benx.encode(%{"a" => 1}) |> Benx.decode!()) === %{"a" => 1}
  end
end
