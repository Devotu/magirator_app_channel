defmodule PlayerControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.PlayerController
    alias MagiratorAppChannel.RoutingPacket


    #Search
    test "search name" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "name" => "Erik" } }
        { status, data } = doAction( "search", routing_packet )
        assert :data == status
        assert is_list data
    end

    test "search name not found" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "name" => "Kent" } }
        { status, data } = doAction( "search", routing_packet )
        assert :data == status
        assert is_list data #Should be list in any case
    end


    #Decks
    test "get player decks" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "id" => 10 } }
        { status, data } = doAction( "decks", routing_packet )
        assert :data == status
        assert is_list data
    end
end