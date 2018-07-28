defmodule PacketTest do
    use ExUnit.Case

    alias MagiratorAppChannel.Packet, as: Packet
    
    test "create packet" do
        packet = %Packet{ domain: "domain", action: "action", data_in: "data_in", data_out: "data_out" }
        assert packet.action == "action"
    end

    test "create empty packet" do
        packet = %Packet{ }
        assert packet.action == ""
    end

    test "create complex packet" do
        packet = %Packet{ domain: "domain", action: "action", data_in: %{ name: "Test", theme: "Stuff" }, data_out: "data_out" }
        assert packet.data_in.name == "Test"  
    end
end