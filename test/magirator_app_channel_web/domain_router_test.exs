defmodule DomainRouterTest do
  use ExUnit.Case
  
  import MagiratorAppChannel.DomainRouter
  alias MagiratorAppChannel.RoutingPacket

  test "route deck" do
    routing_packet = %RoutingPacket{ domain: "deck", action: "create" }
    { status, msg } = route( routing_packet )
    assert :error == status
    assert :invalid_data == msg
  end

  test "route error: no such route" do
    routing_packet = %RoutingPacket{ domain: "" }
    { status, msg } = route( routing_packet )
    assert :error == status
    assert :no_domain_match == msg
  end

  test "route player" do
    routing_packet = %RoutingPacket{ domain: "player", action: "list" }
    { status, data } = route( routing_packet )
    assert :data == status
    assert is_list data
    assert not Enum.empty? data
  end

  test "route game" do
    routing_packet = %RoutingPacket{ 
      domain: "game",
      action: "create",
      user_id: 3, 
      data_in: %{
        "decks" => [23,21],
        "comment" => "Created by GameControllerTest.",
        "conclusion" => "victory"
      }
    }
    { status, data } = route( routing_packet )
    assert :data == status
    assert is_number data
  end
end