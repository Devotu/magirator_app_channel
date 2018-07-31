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
end