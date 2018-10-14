defmodule TokenTest do
    use ExUnit.Case

    alias MagiratorAppChannel.Token
    alias MagiratorAppChannel.Constants

    #Create
    test "create token" do
        {status, token} = Token.create_user_token 99
        assert :ok == status
        assert String.length token == Constants.token_length
    end
end