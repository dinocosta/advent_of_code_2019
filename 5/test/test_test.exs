defmodule TestTest do
  use ExUnit.Case
  doctest TEST
  doctest Instruction
  doctest Memory

  test "1,0,0,0,99 produces correct output" do
    memory = Memory.initialize(["1", "0", "0", "0", "99"])
    expected = %{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

    assert TEST.execute(memory).state == expected
  end

  test "2,3,0,3,99 produces correct output" do
    memory = Memory.initialize(["2", "3", "0", "3", "99"])
    expected = %{0 => 2, 1 => 3, 2 => 0, 3 => 6, 4 => 99}

    assert TEST.execute(memory).state == expected
  end

  test "2,4,4,5,99,0 produces correct output" do
    memory = Memory.initialize(["2", "4", "4", "5", "99", "0"])
    expected = %{0 => 2, 1 => 4, 2 => 4, 3 => 5, 4 => 99, 5 => 9801}

    assert TEST.execute(memory).state == expected
  end

  test "1,1,1,4,99,5,6,0,99 produces correct output" do
    memory = Memory.initialize(["1", "1", "1", "4", "99", "5", "6", "0", "99"])
    expected = %{
      0 => 30,
      1 => 1,
      2 => 1,
      3 => 4,
      4 => 2,
      5 => 5,
      6 => 6,
      7 => 0,
      8 => 99
    }

    assert TEST.execute(memory).state == expected
  end

  test "1002,4,3,4,33 produces correct output" do
    memory = Memory.initialize(["1002", "4", "3", "4", "33"])
    expected = %{
      0 => 1002,
      1 => 4,
      2 => 3,
      3 => 4,
      4 => 99,
    }

    assert TEST.execute(memory).state == expected
  end
end
