defmodule MagiratorAppChannel.DomainRouter do

    alias MagiratorAppChannel.DeckController
    alias MagiratorAppChannel.PlayerController
    alias MagiratorAppChannel.GameController
    
    require Logger

    def route( routing_packet ) do

        Logger.debug "Routing to #{routing_packet.domain} with:"
        Logger.debug Kernel.inspect routing_packet

        _route( routing_packet.domain, routing_packet )
    end

    defp _route( "deck", routing_packet ) do
        DeckController.do_action( routing_packet.action, routing_packet )
    end

    defp _route( "player", routing_packet ) do
        PlayerController.do_action( routing_packet.action, routing_packet )
    end

    defp _route( "game", routing_packet ) do
        GameController.do_action( routing_packet.action, routing_packet )
    end

    defp _route( _domain, _packet ) do
        
        { :error, :no_domain_match }
    end
end