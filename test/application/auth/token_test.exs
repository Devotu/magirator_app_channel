defmodule TokenTest do
    use ExUnit.Case

    alias MagiratorAppChannel.Token
    alias MagiratorAppChannel.Constants

    #Create
    test "create token" do
        {status, token} = Token.create_user_token 99
        assert :ok == status
        assert String.length(token) == Constants.token_length
    end

    #Verify
    test "verify token" do
        {:ok, token} = Token.create_user_token 99
        {status, id} = Token.verify token
        assert :ok == status
        assert 99 == id
    end
end