defmodule DomainRouterTest do
    use ExUnit.Case
    
    import MagiratorAppChannel.DomainRouter
    alias MagiratorAppChannel.Packet, as: Packet

    test "route deck" do
        packet = %Packet{ domain: "deck" }
        {status, _} = route( packet )
        assert :ok == status
    end

    test "route error: no such route" do
        packet = %Packet{ domain: "" }
        {status, _} = route( packet )
        assert :error == status
    end
end