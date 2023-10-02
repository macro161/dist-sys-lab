defmodule TwoFactorAuthTest do
  use ExUnit.Case
  require Logger
  doctest TwoFactorAuth

  setup do
    # Stop the application
    :ok = Application.stop(:two_factor_auth)

    # Start the application
    :ok = Application.start(:two_factor_auth)

    :ok
  end

  test "greets the world" do
    assert TwoFactorAuth.hello() == :world
  end

  test "register and login user" do
    username = "user"
    password = "password"
    wrong_password = "wrong_password"
    wrong_user = "wrong_user"
    device_id = 123
    wrong_device_id = 321

    :ok = Login.register(username, password)
    {:ok,:persistent} = Login.login(username, password, device_id)
    {:ok,:cached} = Login.login(username, wrong_password, device_id)
    :wrong_password = Login.login(username, wrong_password, wrong_device_id)
    :no_user = Login.login(wrong_user, password, device_id)
  end

  test "try to login user when cache is full" do
    username = "user"
    password = "password"
    wrong_password = "wrong_password"
    wrong_user = "wrong_user"
    device_id = 123
    wrong_device_id = 321

    register_and_login(username, password, device_id, wrong_password, wrong_device_id, wrong_user)
    register_and_login("user_two", "password_two", 234, wrong_password, wrong_device_id, wrong_user)
    register_and_login("user_three", "password_three", 345, wrong_password, wrong_device_id, wrong_user)

    :wrong_password = Login.login(username, wrong_password, device_id)
    {:ok,:persistent} = Login.login(username, password, device_id)
    {:ok,:cached} = Login.login(username, wrong_password, device_id)

  end

  def register_and_login(username, password, device_id, wrong_password, wrong_device_id, wrong_user) do
    :ok = Login.register(username, password)
    {:ok,:persistent} = Login.login(username, password, device_id)
    {:ok,:cached} = Login.login(username, wrong_password, device_id)
    :wrong_password = Login.login(username, wrong_password, wrong_device_id)
    :no_user = Login.login(wrong_user, password, device_id)
  end
end
