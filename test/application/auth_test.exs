defmodule AuthTest do
    use ExUnit.Case

    import MagiratorAppChannel.Auth

    test "Valid credentials" do
        
        { status, id } = authenticate( "Adam", "Hemligt" )
        assert :ok == status
        assert 1 == id
    end

    test "Invalid credentials" do
        
        { status, msg } = authenticate( "Folke", "Fel" )
        assert :error == status
        assert :invalid_credentials == msg
    end
end