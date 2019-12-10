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

  test "112233 is a valid password" do
    assert SecureContainer.extra_valid?("112233") == true
  end

  test "123444 is not a valid password" do
    assert SecureContainer.extra_valid?("123444") == false
  end

  test "111122 is a valid password" do
    assert SecureContainer.extra_valid?("111122") == true
  end
end
