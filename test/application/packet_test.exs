defmodule PacketTest do
    use ExUnit.Case

    alias MagiratorAppChannel.RoutingPacket
    
    test "create routing_packet" do
        routing_packet = %RoutingPacket{ domain: "domain", action: "action", data_in: "data_in", data_out: "data_out" }
        assert routing_packet.action == "action"
    end

    test "create empty routing_packet" do
        routing_packet = %RoutingPacket{ }
        assert routing_packet.action == ""
    end

    test "create complex routing_packet" do
        routing_packet = %RoutingPacket{ domain: "domain", action: "action", data_in: %{ name: "Test", theme: "Stuff" }, data_out: "data_out" }
        assert routing_packet.data_in.name == "Test"  
    end
end