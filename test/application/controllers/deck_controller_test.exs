defmodule DeckControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckController
    alias MagiratorAppChannel.Packet
    
    test "create deck" do
        packet = %Packet{ user_id: 1, data_in: %{ name: "DeckControllerTest", theme: "themd"} }
        { status, %{ id: id } } = doAction( "create", packet )
        assert :ok == status
        assert is_number id
    end
    
    test "create deck not valid data" do
        packet = %Packet{ user_id: 1, data_in: %{ name: "xxx" } }
        { status, msg } = doAction( "create", packet )
        assert :error == status
        assert :invalid_data == msg
    end
end