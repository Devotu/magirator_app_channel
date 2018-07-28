defmodule DeckControllerTest do
    use ExUnit.Case

    import MagiratorAppChannel.DeckController
    alias MagiratorAppChannel.Packet
    
    test "create deck" do
        packet = %Packet{ data_in: %{ name: "namy", theme: "themy"} }
        { status, _ } = doAction( "create", packet )
        assert :ok == status
    end
    
    test "create deck not valid data" do
        packet = %Packet{ data_in: %{ name: "xxx" } }
        assert { :error, :invalid_data } == doAction( "create", packet )
    end
end