defmodule DeckControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckController
    alias MagiratorAppChannel.RoutingPacket
    
    test "create deck" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ name: "DeckControllerTest", theme: "themd"} }
        { status, %{ id: id } } = doAction( "create", routing_packet )
        assert :ok == status
        assert is_number id
    end
    
    test "create deck not valid data" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ name: "xxx" } }
        { status, msg } = doAction( "create", routing_packet )
        assert :error == status
        assert :invalid_data == msg
    end
end