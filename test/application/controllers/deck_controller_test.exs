defmodule DeckControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckController
    alias MagiratorAppChannel.RoutingPacket
    
    test "create deck" do
        routing_packet = %RoutingPacket{ 
            user_id: 1, 
            data_in: %{
                "black" => true, 
                "blue" => true, 
                "budget" => 0, 
                "colorless" => false, 
                "format" => "Standard", 
                "green" => false, 
                "name" => "Create", 
                "red" => true, 
                "theme" => "Deck", 
                "white" => false, 
                "worth" => 0
            }
        }
        { status, %{ id: id } } = do_action( "create", routing_packet )
        assert :ok == status
        assert is_number id
    end
    
    test "create deck not valid data" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ name: "xxx" } }
        { status, msg } = do_action( "create", routing_packet )
        assert :error == status
        assert :invalid_data == msg
    end

    test "list decks" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{} }
        { status, data } = do_action( "list", routing_packet )
        assert :data == status
        assert is_list data
    end

    test "list games" do
        routing_packet = %RoutingPacket{ user_id: 1, data_in: %{ "deck_id" => 20 } }
        { status, data } = do_action( "games", routing_packet )
        assert :data == status
        assert is_list data
    end
end