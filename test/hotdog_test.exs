defmodule HotdogTest do
  use ExUnit.Case
  doctest Hotdog

  test "greets the world" do
    assert Hotdog.hello() == :world
  end
end
