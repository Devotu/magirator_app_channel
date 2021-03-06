defmodule PlayerControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.PlayerController
    alias MagiratorAppChannel.RoutingPacket


    #Search
    test "search name" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "name" => "Erik" } }
        { status, data } = do_action( "search", routing_packet )
        assert :data == status
        assert is_list data
        assert {:ok, _} = Enum.fetch data, 0
    end

    test "search name not found" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "name" => "Kent" } }
        { status, data } = do_action( "search", routing_packet )
        assert :data == status
        assert is_list data #Should be list in any case
    end


    #Decks
    test "get player decks" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "id" => 10 } }
        { status, data } = do_action( "decks", routing_packet )
        assert :data == status
        assert is_list data
    end


    #Current
    test "get current player" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{} }
        { status, data } = do_action( "current", routing_packet )
        assert :data == status
        assert !is_list data
        assert Map.has_key? data, :id
    end


    #List
    test "get player list" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{} }
        { status, data } = do_action( "list", routing_packet )
        assert :data == status
        assert is_list data
        assert not Enum.empty? data
        assert Enum.count(data) == 3
    end
end