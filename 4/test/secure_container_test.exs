defmodule SecureContainerTest do
  use ExUnit.Case
  doctest SecureContainer

  test "111111 is a valid password" do
    assert SecureContainer.valid?("111111") == true
  end

  test "223450 is not a valid password" do
    assert SecureContainer.valid?("223450") == false
  end

  test "123789 is not a valid password" do
    assert SecureContainer.valid?("123789") == false
  end
end
